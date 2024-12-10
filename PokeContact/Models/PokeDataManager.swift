//
//  PokeDataManager.swift
//  PokeContact
//
//  Created by 이명지 on 12/10/24.
//
import UIKit
import CoreData

final class PokeDataManager {
    private var container: NSPersistentContainer!
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    func createMember(profileImage: String, name: String, phoneNumber: String) {
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
}

