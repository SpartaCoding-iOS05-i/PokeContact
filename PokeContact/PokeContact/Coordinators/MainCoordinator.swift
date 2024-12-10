//
//  MainCoordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func navigateToAddContact()
    func navigateToEditContact(contact: Contact)
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let detailCoordinatorFactory: () -> DetailCoordinatorProtocol
    private let contactRepository: ContactRepository
    
    init(
        navigationController: UINavigationController,
        detailCoordinatorFactory: @escaping () -> DetailCoordinatorProtocol,
        contactRepository: ContactRepository
    ) {
        self.navigationController = navigationController
        self.detailCoordinatorFactory = detailCoordinatorFactory
        self.contactRepository = contactRepository
    }
    
    internal func start() {
        let viewModel = MainViewModel(
            coordinator: self,
            repository: contactRepository
        )
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: MainCoordinatorProtocol {
    func navigateToAddContact() {
        let detailCoordinator = detailCoordinatorFactory() as! DetailCoordinator
        let detailViewModel = DetailViewModel(coordinator: detailCoordinator, repository: contactRepository)
        let detailViewController = DetailViewController(viewModel: detailViewModel, mode: .add)
        
        var isOnSaveCalled = false
        
        print("MainCoordinator: Setting onSave for detailViewModel")
        
        detailViewModel.onSave = { [weak self] (newContact: Contact) in
            guard let self = self else { return }
            
            if isOnSaveCalled {
                print("MainCoordinator: onSave already called, skipping")
                return
            }
            isOnSaveCalled = true
            
            print("MainCoordinator: onSave called with new contact: \(newContact)")
                    guard let fullName = newContact.fullName, let phoneNumber = newContact.phoneNumber else {
                        print("Error: Contact data is incomplete")
                        return
                    }
                    do {
                        try self.contactRepository.addContact(name: fullName, phone: phoneNumber)
                        print("MainCoordinator: Contact added successfully")
                        self.refreshMainView()
                    } catch {
                        print("Failed to add contact: \(error)")
                    }
        }
        
        detailCoordinator.start(with: detailViewController)
        childCoordinators.append(detailCoordinator)
    }
    
    func navigateToEditContact(contact: Contact) {
        let detailCoordinator = detailCoordinatorFactory() as! DetailCoordinator
        let detailViewModel = DetailViewModel(coordinator: detailCoordinator, repository: contactRepository)
        let detailViewController = DetailViewController(viewModel: detailViewModel, mode: .edit(contact: contact))
        
        print("MainCoordinator: Setting onSave for detailViewModel")
        
        detailViewModel.onSave = { [weak self] (updatedContact: Contact) in
            print("MainCoordinator: onSave called with updated contact: \(updatedContact)")
            guard let self = self else { return }
            guard let fullName = updatedContact.fullName, let phoneNumber = updatedContact.phoneNumber else {
                print("Error: Contact data is incomplete")
                return
            }
            do {
                try self.contactRepository.updateContact(contact, withName: fullName, andPhone: phoneNumber)
                print("Updated contact successfully.")
                self.refreshMainView()
            } catch {
                print("Failed to update contact: \(error)")
            }
        }
        
        print("MainCoordinator: detailViewModel.onSave is \(detailViewModel.onSave == nil ? "nil" : "set")")
        
        detailCoordinator.start(with: detailViewController)
        childCoordinators.append(detailCoordinator)
    }
    
    private func refreshMainView() {
        print("Refreshing Main View.")
        if let mainViewController = navigationController.viewControllers.first(where: { $0 is MainViewController }) as? MainViewController {
            mainViewController.viewModel.fetchContacts()
        }
        print("Refreshed Main View successfully.")
    }
}
