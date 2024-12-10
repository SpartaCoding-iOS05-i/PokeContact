//
//  ContactCell.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-10.
//

import UIKit
import SnapKit
import Then

class ContactCell: UITableViewCell {
    static let identifier = "ContactCell"
    
    private let profileImage = RoundImageView().then {
        $0.image = UIImage(systemName: "star")
    }
    
    private let nameLabel = UILabel().then {
        $0.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        $0.textColor = .label
    }
    
    private let phoneLabel = UILabel().then {
        $0.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        $0.textColor = .label
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        [
            profileImage,
            nameLabel,
            phoneLabel
        ].forEach { self.contentView.addSubview($0) }
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(35)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalTo(profileImage.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(35)
        }
    }
    // MARK: - Data Configuration
    func configure(with contact: Contact) {
        nameLabel.text = contact.fullName
        phoneLabel.text = contact.phoneNumber
    }
}

// MARK: - ImageView Subclass
class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = bounds.height / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
