//
//  AppCoordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import CoreData
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let context: NSManagedObjectContext
    
    init(window: UIWindow, navigationController: UINavigationController, context: NSManagedObjectContext) {
        self.window = window
        self.navigationController = navigationController
        self.context = context
    }
    
    func start() {
        let contactRepository = ContactRepository(context: context)
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            detailCoordinatorFactory: { DetailCoordinator(navigationController: self.navigationController) },
            contactRepository: contactRepository
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
