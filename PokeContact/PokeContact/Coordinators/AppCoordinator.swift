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
    private let pokemonFetcher = PokemonFetcher()
    
    init(window: UIWindow, navigationController: UINavigationController, context: NSManagedObjectContext) {
        self.window = window
        self.navigationController = navigationController
        self.context = context
    }
    
    func start() {
        let contactRepository = ContactRepository(
            context: context,
            pokemonFetcher: pokemonFetcher
        )

        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
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
