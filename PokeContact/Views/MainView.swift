//
//  MainView.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit

protocol MainViewDelegate: AnyObject {
    func numberOfContacts() -> Int
    func contactOfIndex(at indexPath: IndexPath) -> Contact
    func didSelectContact(at indexPath: IndexPath)
    func deleteContact(at indexPath: IndexPath)
}

final class MainView: UIView {
    // MARK: - Properites
    private let tableView = UITableView()
    weak var delegate: MainViewDelegate?
    
    // MARK: - Initailizer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    private func configureTableView() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Set TableView data
    func reloadData() {
        self.tableView.reloadData()
    }
}

// MARK: - TableView Methods
extension MainView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate?.numberOfContacts() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        if let contact = self.delegate?.contactOfIndex(at: indexPath) {
            cell.configureCellData(contact)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.didSelectContact(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delegate?.deleteContact(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}
