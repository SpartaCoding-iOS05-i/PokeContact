//
//  DetailCoordinator.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit

protocol DetailCoordinatorProtocol: AnyObject {
    func saveDetailData()
}

class DetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    func start() {
        
    }
}

extension DetailCoordinator: DetailCoordinatorProtocol {
    func saveDetailData() {
        
    }
}
