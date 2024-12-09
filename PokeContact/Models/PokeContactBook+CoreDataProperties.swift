//
//  PokeContactBook+CoreDataProperties.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
//

import Foundation
import CoreData


extension PokeContactBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokeContactBook> {
        return NSFetchRequest<PokeContactBook>(entityName: "PokeContactBook")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profileImage: String?

}

extension PokeContactBook : Identifiable {

}
