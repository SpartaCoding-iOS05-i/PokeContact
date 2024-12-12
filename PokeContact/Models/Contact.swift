//
//  Contact.swift
//  PokeContact
//
//  Created by 이명지 on 12/12/24.
//

import CoreData

struct Contact {
    let name: String
    let phoneNumber: String
    let profileImage: String
    
    init(name: String, phoneNumber: String, profileImage: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
    }
    
    init(_ object: NSManagedObject) {
        self.name = object.value(forKey: PokeContactBook.Key.name) as? String ?? ""
        self.phoneNumber = object.value(forKey: PokeContactBook.Key.phoneNumber) as? String ?? ""
        self.profileImage = object.value(forKey: PokeContactBook.Key.profileImage) as? String ?? ""
    }
}
