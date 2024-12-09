//
//  MainViewController.swift
//  PokeContact
//
//  Created by 권승용 on 12/9/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let contactTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        configureUI()
    }
    
    private func setDelegates() {
        contactTableView.delegate = self
        contactTableView.dataSource = self
    }
    
    private func configureUI() {
        let subviews = [
            contactTableView
        ]
        
        subviews.forEach {
            view.addSubview($0)
        }
        
        contactTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contact.dummies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else {
            return ContactTableViewCell()
        }
        
        cell.configureCell(with: Contact.dummies[indexPath.row])
        return cell
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
