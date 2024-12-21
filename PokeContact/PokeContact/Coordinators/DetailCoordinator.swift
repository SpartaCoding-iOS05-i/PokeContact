//
//  DetailCoordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit

protocol DetailCoordinatorProtocol: AnyObject {
    func navigateBack()
}

class DetailCoordinator {
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
    
    func start(with mode: ContactMode) {
        let detailViewModel = DetailViewModel(
            coordinator: self,
            repository: contactRepository
        )
        
        let detailViewController = DetailViewController(
            viewModel: detailViewModel,
            mode: mode
        )
        
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

extension DetailCoordinator: DetailCoordinatorProtocol {
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}

extension DetailCoordinator: Coordinator {
    func start() {}
}
