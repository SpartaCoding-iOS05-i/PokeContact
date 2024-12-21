//
//  MainViewModel.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {}

class MainViewModel {
    private weak var coordinator: MainCoordinatorProtocol?
    weak var delegate: MainViewModelDelegate?
    private let repository: ContactRepository
    var contacts: [Contact] = []
    var onDataUpdated: (() -> Void)?
    
    init(coordinator: MainCoordinatorProtocol, repository: ContactRepository) {
        self.coordinator = coordinator
        self.repository = repository
    }
    
    // MARK: - Navigation
    func didTapNavigate() {
        coordinator?.navigateToAddContact()
    }
    
    func didSelectContact(at index: Int) {
        guard index < contacts.count else { return }
        coordinator?.navigateToEditContact(contact: contacts[index])
    }
    
    // MARK: - Data Operations
    func fetchContacts() {
        do {
            contacts = try repository.fetchContacts()
            print("MainViewModel: Fetched contacts: \(contacts)")
            onDataUpdated?()
        } catch {
            print("MainViewModel: Failed to fetch contacts: \(error)")
        }
    }
    
    func deleteContact(at index: Int) {
        guard index < contacts.count else { return }
        let contact = contacts[index]
        do {
            print("MainViewModel: Deleting contact: \(contact)")
            try repository.deleteContact(contact)
            fetchContacts()
        } catch {
            print("MainViewModel: Failed to delete contact: \(error)")
        }
    }
}
