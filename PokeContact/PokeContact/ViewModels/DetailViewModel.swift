//
//  DetailViewModel.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func didSaveContact()
    func didFailWithError(_ error: Error)
}

class DetailViewModel {
    weak var coordinator: DetailCoordinatorProtocol?
    weak var delegate: DetailViewModelDelegate?
    private(set) var repository: ContactRepository
    
    var onSave: ((Contact) -> Void)?
    
    init(coordinator: DetailCoordinatorProtocol?, repository: ContactRepository) {
        self.coordinator = coordinator
        self.repository = repository
    }
    
    // MARK: - Fetch Random Pokemon Image
    func fetchRandomImage() async throws -> String {
        do {
            let spriteURL = try await repository.fetchRandomImageURL()
            print("DetailViewModel: Successfully fetched random image URL: \(spriteURL)")
            return spriteURL
        } catch {
            print("DetailViewModel: Failed to fetch random image URL: \(error)")
            throw error
        }
    }
    
    // MARK: - Save New Contact
    func addContact(name: String, phone: String, imageURL: String) throws {
        print("DetailViewModel: Attempting to add contact - Name: \(name), Phone: \(phone), ImageURL: \(imageURL)")
        
        do {
            let newContact = try repository.addContact(name: name, phone: phone, imageURL: imageURL)
            print("DetailViewModel: Contact added successfully: \(newContact)")
            
            // Notify via onSave
            self.onSave?(newContact)
            self.delegate?.didSaveContact()
            self.coordinator?.navigateBack()
        } catch {
            print("DetailViewModel: Failed to add contact: \(error)")
            delegate?.didFailWithError(error)
            throw error
        }
    }
    
    // MARK: - Update Existing Contact
    func updateContact(_ contact: Contact, withName name: String, phone: String, imageURL: String) {
        print("DetailViewModel: Attempting to update contact - Name: \(name), Phone: \(phone), ImageURL: \(imageURL)")
        
        do {
            try repository.updateContact(contact, withName: name, phone: phone, andImageURL: imageURL)
            print("DetailViewModel: Successfully updated contact.")
            self.onSave?(contact)
            self.delegate?.didSaveContact()
            self.coordinator?.navigateBack()
        } catch {
            print("DetailViewModel: Failed to update contact: \(error)")
            self.delegate?.didFailWithError(error)
        }
    }
}
