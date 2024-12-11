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
    private let contactRepository: ContactRepository
    
    init(
        navigationController: UINavigationController,
        contactRepository: ContactRepository
    ) {
        self.navigationController = navigationController
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
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            contactRepository: contactRepository
        )
        
        self.childCoordinators.append(detailCoordinator)
        detailCoordinator.start(with: .add)
    }
    
    func navigateToEditContact(contact: Contact) {
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            contactRepository: contactRepository
        )
        
        self.childCoordinators.append(detailCoordinator)
        detailCoordinator.start(with: .edit(contact: contact))
    }
    
    private func refreshMainView() {
        print("MainCoordinator: Refreshing Main View.")
        if let mainViewController = navigationController.viewControllers.first(where: { $0 is MainViewController }) as? MainViewController {
            mainViewController.viewModel.fetchContacts()
        }
        print("MainCoordinator: Main View refreshed successfully.")
    }
}
