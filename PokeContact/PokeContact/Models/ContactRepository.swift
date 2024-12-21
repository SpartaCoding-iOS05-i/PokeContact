//
//  ContactRepository.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import CoreData

class ContactRepository {
    private(set) var context: NSManagedObjectContext
    private let pokemonFetcher: PokemonFetcher
    
    init(context: NSManagedObjectContext, pokemonFetcher: PokemonFetcher) {
        self.context = context
        self.pokemonFetcher = pokemonFetcher
    }
    
    func fetchContacts() throws -> [Contact] {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.includesPendingChanges = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "fullName", ascending: true)]
        
        do {
            let contacts = try context.fetch(fetchRequest)
            print("ContactRepository: Fetched \(contacts.count) contacts.")
            return contacts
        } catch {
            print("ContactRepository: Failed to fetch contacts: \(error)")
            throw error
        }
    }
    
    func fetchRandomImageURL() async throws -> String {
        print("ContactRepository: Fetching random image URL from Pokémon API")
        do {
            let spriteURL = try await pokemonFetcher.fetchRandomPokemonSpriteURL()
            print("ContactRepository: Successfully fetched random image URL: \(spriteURL)")
            return spriteURL
        } catch {
            print("ContactRepository: Failed to fetch random image URL: \(error)")
            throw error
        }
    }

    func addContact(name: String, phone: String, imageURL: String) throws -> Contact {
        print("ContactRepository: Adding contact with name: \(name), phone: \(phone), imageURL: \(imageURL)")

        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "fullName == %@ AND phoneNumber == %@", name, phone)
        fetchRequest.includesPendingChanges = false

        let existingContacts = try context.fetch(fetchRequest)
        if !existingContacts.isEmpty {
            print("ContactRepository: Duplicate contact found, skipping addition")
            throw NSError(domain: "DuplicateContact", code: 409, userInfo: [NSLocalizedDescriptionKey: "Duplicate contact found."])
        }

        let contact = Contact(context: context)
        contact.fullName = name
        contact.phoneNumber = phone
        contact.profileImage = imageURL

        do {
            try context.save()
            print("ContactRepository: Contact added successfully")
            return contact
        } catch {
            print("ContactRepository: Failed to save contact: \(error)")
            throw error
        }
    }

    func updateContact(_ contact: Contact, withName name: String, phone: String, andImageURL imageURL: String) throws {
        print("ContactRepository: Updating contact with name: \(name), phone: \(phone), imageURL: \(imageURL)")
        
        contact.fullName = name
        contact.phoneNumber = phone
        contact.profileImage = imageURL
        
        do {
            try context.save()
            print("ContactRepository: Contact updated successfully")
        } catch {
            print("ContactRepository: Failed to update contact: \(error)")
            throw error
        }
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
