//
//  AddMemberViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit

final class AddMemberViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = AddMemberView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(completeButtonTapped))
    }
    
    @objc private func completeButtonTapped() {
        
    }
}
