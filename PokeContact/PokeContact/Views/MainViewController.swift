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
    private let tableView = UITableView()
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
        setupTableView()
        bindViewModel()
        viewModel.fetchContacts()
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
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = viewModel.contacts[indexPath.row]
        cell.textLabel?.text = contact.fullName
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = viewModel.contacts[indexPath.row]
        print("Selected contact: \(viewModel.contacts[indexPath.row])")
    }
    
    func tableview(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteContact(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
