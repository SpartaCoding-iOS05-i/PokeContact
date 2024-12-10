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
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
