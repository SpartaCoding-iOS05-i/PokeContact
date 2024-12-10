//
//  DetailViewModel.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

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
    
    func saveData(name: String, phone: String) {
        do {
            try repository.addContact(name: name, phone: phone)
            delegate?.didSaveContact()
            coordinator?.navigateBack()
        } catch {
            delegate?.didFailWithError(error)
        }
    }
}
