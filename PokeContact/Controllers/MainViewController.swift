//
//  MainViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {
    private let mainView = MainView()
    private var container: NSPersistentContainer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.navigationController?.pushViewController(addMemberViewController, animated: true)
    }
    
    private func bind() {
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.container = appDelegate.persistentContainer
            let pokeContacts = try self.container.viewContext.fetch(PokeContactBook.fetchRequest())
            mainView.configurePokeContacts(contacts: pokeContacts)
        } catch {
            print("데이터 읽기 실패")
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
