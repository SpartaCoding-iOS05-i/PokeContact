//
//  MainViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {
    // MARK: - Properties
    private let mainView = MainView()
    private let pokeContactManager = PokeContactManager()
    private var contacts = [NSManagedObject]()
    
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
        guard let contacts = pokeContactManager.readContacts() else { return }
        self.contacts = contacts
        self.mainView.reloadData()
    }
}

// MARK: - PokeTableViewCellDelegate
extension MainViewController: PokeTableViewCellDelegate {
    func numberOfContacts() -> Int {
        return contacts.count
    }
    
    func contactOfIndex(at indexPath: IndexPath) -> Contact {
        return Contact(contacts[indexPath.row])
    }
    
    func didSelectContact(at indexPath: IndexPath) {
        let selectedContact = Contact(contacts[indexPath.row])
        let contactViewController = ContactViewController(selectedContact)
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func deleteContact(at indexPath: IndexPath) {
        let deleteContact = Contact(contacts[indexPath.row])
        pokeContactManager.deleteContact(deleteContact)
        contacts.remove(at: indexPath.row)
        self.mainView.reloadData()
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
