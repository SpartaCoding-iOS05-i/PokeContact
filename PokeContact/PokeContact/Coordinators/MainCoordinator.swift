//
//  MainCoordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func navigateToDetail()
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
    internal func navigateToDetail() {
        let detailCoordinator = detailCoordinatorFactory()
        let detailViewModel = DetailViewModel(coordinator: detailCoordinator)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
