//
//  MainViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//

import UIKit

final class MainViewController: UIViewController {
    private let mainView = MainView()
    private let pokeDataManager = PokeDataManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        view = mainView
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "친구 목록"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addMemberButtonTapped))
    }
    
    @objc private func addMemberButtonTapped() {
        let addMemberViewController = AddMemberViewController()
        addMemberViewController.configurePokeProfile()
        self.navigationController?.pushViewController(addMemberViewController, animated: true)
    }
    
    private func bind() {
        guard let contacts = pokeDataManager.readMembers() else { return }
        self.mainView.configurePokeContacts(contacts: contacts) 
    }
}

extension MainViewController: PokeTableViewCellDelegate {
    func cellDidTapped(profileImage: String, name: String, phoneNumber: String) {
        let addMemberViewController = AddMemberViewController(profileImage: profileImage, name: name, phoneNumber: phoneNumber)
        self.navigationController?.pushViewController(addMemberViewController, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
