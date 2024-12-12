//
//  PokeDataManager.swift
//  PokeContact
//
//  Created by 이명지 on 12/10/24.
//
import UIKit
import CoreData

final class PokeDataManager {
    // MARK: - Property
    private var container: NSPersistentContainer!
    
    // MARK: - Initailzer
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    // MARK: - Data CRUD Funtions
    func createContact(profileImage: String, name: String, phoneNumber: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: PokeContactBook.className, in: self.container.viewContext) else { return }
        
        let newPoke = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPoke.setValue(profileImage, forKey: PokeContactBook.Key.profileImage)
        newPoke.setValue(name, forKey: PokeContactBook.Key.name)
        newPoke.setValue(phoneNumber, forKey: PokeContactBook.Key.phoneNumber)
        
        do {
            try self.container.viewContext.save()
            print("context save 성공")
        } catch {
            print("context svae 실패")
        }
    }
    
    func readContacts() -> [NSManagedObject]? {
        do {
            let sortDescriptor = NSSortDescriptor(key: PokeContactBook.Key.name, ascending: true)
            PokeContactBook.fetchRequest().sortDescriptors = [sortDescriptor]
            return try self.container.viewContext.fetch(PokeContactBook.fetchRequest())
        } catch {
            print("데이터 읽기 실패")
            return nil
        }
    }
    
    func updateContact(currentName: String, updateProfileImage: String, updateName: String, updatePhoneNumber: String) {
        let fetchRequest = PokeContactBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentName)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                data.setValue(updateProfileImage, forKey: PokeContactBook.Key.profileImage)
                data.setValue(updateName, forKey: PokeContactBook.Key.name)
                data.setValue(updatePhoneNumber, forKey: PokeContactBook.Key.phoneNumber)
                
                try self.container.viewContext.save()
                print("데이터 수정 완료")
            }
            
        } catch {
            print("데이터 수정 실패")
        }
    }
    
    func deleteContact(_ contact: Contact) {
        let fetchRequest = PokeContactBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", contact.name)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
            }
            try self.container.viewContext.save()
            print("데이터 삭제 완료")
            
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
    }
}

