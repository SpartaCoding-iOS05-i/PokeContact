//
//  DetailViewModel.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

protocol DetailViewModelDelegate: AnyObject {
    
}

class DetailViewModel {
    private weak var coordinator: DetailCoordinatorProtocol?
    weak var delegate: DetailViewModelDelegate?
    
    init(coordinator: DetailCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func saveData() {
        coordinator?.saveDetailData()
    }
}
