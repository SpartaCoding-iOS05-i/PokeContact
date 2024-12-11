//
//  ContactRepository.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import CoreData

class ContactRepository {
    private(set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchContacts() throws -> [Contact] {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.includesPendingChanges = false
        return try context.fetch(fetchRequest)
    }

    func addContact(name: String, phone: String) throws {
        print("ContactRepository: Adding contact with name: \(name), phone: \(phone)")

        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "fullName == %@ AND phoneNumber == %@", name, phone)
        fetchRequest.includesPendingChanges = false

        let existingContacts = try context.fetch(fetchRequest)
        print("ContactRepository: Existing contacts for duplication: \(existingContacts)")

        if !existingContacts.isEmpty {
            print("ContactRepository: Duplicate contact found, skipping addition")
            return
        }

        let contact = Contact(context: context)
        contact.fullName = name
        contact.phoneNumber = phone

        do {
            try context.save()
            print("ContactRepository: Contact added successfully")
        } catch {
            print("ContactRepository: Failed to save contact: \(error)")
            throw error
        }
    }
    
    func updateContact(_ contact: Contact, withName name: String, andPhone phone: String) throws {
        print("ContactRepository: Updating contact with name \(name) and phone \(phone)")
        contact.fullName = name
        contact.phoneNumber = phone
        try context.save()
        print("ContactRepository: Contact updated successfully")
    }
    
    func deleteContact(_ contact: Contact) throws {
        context.delete(contact)
        try context.save()
    }
    
    func clearAllContacts() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Contact.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
        print("ContactRepository: Cleared all contacts from CoreData.")
    }
}
