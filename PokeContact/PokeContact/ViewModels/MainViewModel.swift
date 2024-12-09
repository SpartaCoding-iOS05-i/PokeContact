//
//  MainViewModel.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

protocol MainViewModelDelegate: AnyObject {
    
}

class MainViewModel {
    private weak var coordinator: MainCoordinatorProtocol?
    weak var delegate: MainViewModelDelegate?
    
    init(coordinator: MainCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func didTapNavigate() {
        coordinator?.navigateToDetail()
    }
}
