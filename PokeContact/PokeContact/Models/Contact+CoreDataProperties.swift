//
//  Contact+CoreDataProperties.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-10.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var profileImage: String?
    @NSManaged public var fullName: String?
    @NSManaged public var phoneNumber: String?

}

extension Contact : Identifiable {

}
