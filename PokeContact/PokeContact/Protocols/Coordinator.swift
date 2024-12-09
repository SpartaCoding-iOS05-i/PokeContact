//
//  Coordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
