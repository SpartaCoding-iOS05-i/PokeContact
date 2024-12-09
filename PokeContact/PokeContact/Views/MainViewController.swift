//
//  MainViewController.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit
import SnapKit
import Then

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
        
        let button = UIButton(type: .system).then {
            $0.setTitle("Button", for: .normal)
            $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }
        
        [
            button,
        ].forEach { view.addSubview($0) }

        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }
    }
    
    @objc private func didTapButton() {
        viewModel.didTapNext()
    }
}

