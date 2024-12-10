//
//  MainViewModel.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

protocol MainViewModelDelegate: AnyObject {
    
}

class MainViewModel {
    private weak var coordinator: MainCoordinatorProtocol?
    weak var delegate: MainViewModelDelegate?
    private let repository: ContactRepository
    private(set) var contacts: [Contact] = []
    var onDataUpdated: (() -> Void)?
    
    init(coordinator: MainCoordinatorProtocol, repository: ContactRepository) {
        self.coordinator = coordinator
        self.repository = repository
    }
    
    // MARK: - Navigation
    func didTapNavigate() {
        coordinator?.navigateToDetail()
    }
    
    // MARK: - Data Operations
    func fetchContacts() {
        do {
            contacts = try repository.fetchContacts()
            onDataUpdated?()
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
    
    func addContact(name: String, phone: String) {
        do {
            try repository.addContact(name: name, phone: phone)
            fetchContacts()
        } catch {
            print("Failed to add contact: \(error)")
        }
    }
    
    func deleteContact(at index: Int) {
        guard index < contacts.count else { return }
        let contact = contacts[index]
        do {
            try repository.deleteContact(contact)
            fetchContacts()
        } catch {
            print("Faield to delete contact: \(error)")
        }
    }
}
