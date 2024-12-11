//
//  DetailCoordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit

protocol DetailCoordinatorProtocol: AnyObject {
    func navigateBack()
    func start(with viewController: UIViewController)
}

class DetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // Use navigationController instead
    }
}

extension DetailCoordinator: DetailCoordinatorProtocol {
    func start(with viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
