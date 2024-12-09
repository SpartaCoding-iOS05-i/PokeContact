//
//  AppCoordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            detailCoordinatorFactory: { DetailCoordinator() }
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        
        setupWindow()
    }
    
    private func setupWindow() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
