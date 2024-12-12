//
//  MainViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Properties
    private let mainView = MainView()
    private let pokeDataManager = PokeDataManager()
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Functions
    private func setupView() {
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
        let contactViewController = ContactViewController()
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    private func bind() {
        guard let contacts = pokeDataManager.readMembers() else { return }
        self.mainView.configurePokeContacts(contacts: contacts) 
    }
}

// MARK: - PokeTableViewCellDelegate
extension MainViewController: PokeTableViewCellDelegate {
    func cellDidTapped(_ contact: Contact) {
        let contactViewController = ContactViewController(contact)
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func deleteCell(name: String) {
        pokeDataManager.deleteMember(name: name)
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
