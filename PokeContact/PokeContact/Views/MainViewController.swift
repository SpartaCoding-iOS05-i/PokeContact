//
//  MainViewController.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit

class MainViewController: UIViewController {
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
    }

    private func configureUI() {
        view.backgroundColor = .systemPink
        let button = UIButton(type: .system)
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),  // 가로축 중앙 정렬
                button.centerYAnchor.constraint(equalTo: view.centerYAnchor),  // 세로축 중앙 정렬
                button.widthAnchor.constraint(equalToConstant: 120),           // 버튼 너비
                button.heightAnchor.constraint(equalToConstant: 44)            // 버튼 높이
            ])
        
    }
    
    @objc private func didTapButton() {
        viewModel.didTapNext()
    }
}

