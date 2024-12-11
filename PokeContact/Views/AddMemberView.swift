//
//  AddMemberView.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit

protocol RandomImageButtonDelegate: AnyObject {
    func changeRandomImage()
}

final class AddMemberView: UIView {
    weak var delegate: RandomImageButtonDelegate?
    
    private(set) var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let randomImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    private(set) var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "닉네임"
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private(set) var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "전화번호"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, randomImageButton, nameTextField, phoneNumberTextField])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    init(profileImage: String, name: String, phoneNumber: String) {
        super.init(frame: .zero)
        self.profileImageView.image = profileImage.toUIImage()
        self.nameTextField.text = name
        self.phoneNumberTextField.text = phoneNumber
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(stackView)
        self.randomImageButton.addTarget(self, action: #selector(randomImageButtonTapped), for: .touchUpInside)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            
            nameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            phoneNumberTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureProfileImage(image: UIImage) {
        self.profileImageView.image = image
    }
    
    @objc private func randomImageButtonTapped() {
        delegate?.changeRandomImage()
    }
}
