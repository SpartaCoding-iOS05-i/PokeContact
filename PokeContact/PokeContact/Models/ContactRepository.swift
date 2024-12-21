//
//  ContactRepository.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import CoreData

class ContactRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchContacts() throws -> [Contact] {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    func addContact(name: String, phone: String) throws {
        let contact = Contact(context: context)
        contact.fullName = name
        contact.phoneNumber = phone
        try context.save()
    }
    
    func deleteContact(_ contact: Contact) throws {
        context.delete(contact)
        try context.save()
    }
}
