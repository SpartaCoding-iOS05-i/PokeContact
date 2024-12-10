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
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "Model")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private init() { }
}

extension CoreDataStack {
    // Add a convenience method to commit changes to the store.
    func save() {
        // Verify that the context has uncommitted changes.
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            // Attempt to save changes.
            try persistentContainer.viewContext.save()
        } catch {
            // Handle the error appropriately.
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func createData(name: String, phoneNumber: String, profileImage: Data) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ContactEntity", in: persistentContainer.viewContext) else {
            return
        }
        let newContact = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
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
            if let name = contactEntity.value(forKey: "name") as? String,
               let phoneNumber = contactEntity.value(forKey: "phoneNumber") as? String,
               let profileImage = contactEntity.value(forKey: "profileImage") as? Data {
                let newContact = Contact(
                    name: name,
                    phoneNumber: phoneNumber,
                    profileImage: profileImage
                )
                result.append(newContact)
            }
        }
        return result
    }
    
    func deleteData(item: ContactEntity) {
        persistentContainer.viewContext.delete(item)
        save()
    }
}
