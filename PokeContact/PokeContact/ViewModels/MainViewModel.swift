//
//  MainViewModel.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

class MainViewModel {
    weak var coordinator: MainCoordinator?
    
    func didTapNext() {
        coordinator?.navigateToDetail()
    }
}
