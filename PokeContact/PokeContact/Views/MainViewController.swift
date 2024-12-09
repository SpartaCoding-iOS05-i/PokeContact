//
//  MainViewController.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit
import SnapKit
import Then

class MainViewController: UIViewController, MainViewModelDelegate {
    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.delegate = self
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.title = "Friend List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didTapButton))
        
        
    }
    
    @objc private func didTapButton() {
        viewModel.didTapNavigate()
    }
}

