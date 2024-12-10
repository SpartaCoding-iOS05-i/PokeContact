//
//  MainViewController.swift
//  PokeContact
//
//  Created by 권승용 on 12/9/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private let contactTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        return tableView
    }()
    
    private var contacts: [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        configureUI()
        configureButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        do {
            contacts = try CoreDataStack.shared.readAllData()
            contactTableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
            contacts = []
        }
    }
    
    private func setDelegates() {
        contactTableView.delegate = self
        contactTableView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let subviews = [
            titleLabel,
            addButton,
            contactTableView
        ]
        
        subviews.forEach {
            view.addSubview($0)
        }
     
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(titleLabel)
        }
        
        contactTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func configureButtonAction() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
}

private extension MainViewController {
    @objc
    func addButtonTapped() {
        navigationController?.pushViewController(AddContactViewController(), animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else {
            return ContactTableViewCell()
        }
        
        cell.configureCell(with: contacts[indexPath.row])
        return cell
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
