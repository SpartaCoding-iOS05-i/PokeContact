//
//  CoreDataStack.swift
//  PokeContact
//
//  Created by 권승용 on 12/10/24.
//

import Foundation
import CoreData

final class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private init() { }
}

extension CoreDataStack {
    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func createData(name: String, phoneNumber: String, profileImage: Data) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ContactEntity", in: persistentContainer.viewContext) else {
            return
        }
        let newContact = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        newContact.setValue(UUID(), forKey: "id")
        newContact.setValue(name, forKey: "name")
        newContact.setValue(phoneNumber, forKey: "phoneNumber")
        newContact.setValue(profileImage, forKey: "profileImage")
        save()
    }
    
    func readAllData() throws -> [Contact] {
        var result: [Contact] = []
        
        let request: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
        let contactEntities = try persistentContainer.viewContext.fetch(request)
        for contactEntity in contactEntities as [NSManagedObject] {
            if let id = contactEntity.value(forKey: "id") as? UUID,
               let name = contactEntity.value(forKey: "name") as? String,
               let phoneNumber = contactEntity.value(forKey: "phoneNumber") as? String,
               let profileImage = contactEntity.value(forKey: "profileImage") as? Data {
                let newContact = Contact(
                    id: id,
                    name: name,
                    phoneNumber: phoneNumber,
                    profileImage: profileImage
                )
                result.append(newContact)
            }
        }
        return result
    }
    
    func updateData(id: UUID, name: String, phoneNumber: String, profileImage: Data) throws {
        let fetchRequest = ContactEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let result = try persistentContainer.viewContext.fetch(fetchRequest)
        
        for data in result as [NSManagedObject] {
            data.setValue(name, forKey: "name")
            data.setValue(phoneNumber, forKey: "phoneNumber")
            data.setValue(profileImage, forKey: "profileImage")
            save()
        }
    }
    
    func deleteData(item: Contact) throws {
        let request = ContactEntity.fetchRequest()
        request.predicate = NSPredicate(format: "phoneNumber == %@", item.phoneNumber)
        
        let result = try self.persistentContainer.viewContext.fetch(request)
        for data in result as [NSManagedObject] {
            persistentContainer.viewContext.delete(data)
        }
        save()
    }
}
