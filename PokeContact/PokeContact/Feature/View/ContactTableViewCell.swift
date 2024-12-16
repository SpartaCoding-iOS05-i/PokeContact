//
//  ContactTableViewCell.swift
//  PokeContact
//
//  Created by 권승용 on 12/9/24.
//

import UIKit

final class ContactTableViewCell: UITableViewCell {
    static let identifier = "ContactTableViewCell"
    
    // MARK: - View Property
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "010-1111-1111"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not using storyboard")
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        let subviews = [
            profileImageView,
            nameLabel,
            phoneNumberLabel
        ]
        
        // contentView에 서브뷰를 추가해줘야 편집 모드 진입 등의 상황에서 올바른 위치를 가지게 된다.
        subviews.forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Cell Configuration
extension ContactTableViewCell {
    
    func configureCell(with contact: Contact) {
        // TODO: 이미지 로드 기능 추가
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.phoneNumber
    }
}

@available(iOS 17, *)
#Preview {
    ContactTableViewCell(style: .default, reuseIdentifier: ContactTableViewCell.identifier)
}
