//
//  MainCoordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    internal func start() {
        let viewModel = MainViewModel()
        let viewController = MainViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator {
    internal func navigateToDetail() {
        let detailViewModel = DetailViewModel()
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
