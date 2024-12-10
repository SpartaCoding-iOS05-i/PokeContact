//
//  MainView.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit
import CoreData

final class MainView: UIView {
    private let tableView = UITableView()
    private var contacts = [NSManagedObject]()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func configurePokeContacts(contacts: [NSManagedObject]) {
        self.contacts = contacts
        self.tableView.reloadData()
    }
}

extension MainView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        let contact = contacts[indexPath.row]
        let profileImage = contact.value(forKey: PokeContactBook.Key.profileImage) as? String ?? ""
        let name = contact.value(forKey: PokeContactBook.Key.name) as? String ?? ""
        let phoneNumber = contact.value(forKey: PokeContactBook.Key.phoneNumber) as? String ?? ""
        cell.configureCellData(profileImage: profileImage, name: name, phoneNumber: phoneNumber)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
