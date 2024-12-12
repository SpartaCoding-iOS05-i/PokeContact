//
//  AddContactViewController.swift
//  PokeContact
//
//  Created by 권승용 on 12/9/24.
//

import UIKit
import SnapKit

enum EditMode {
    case add
    case modify
}

final class AddContactViewController: UIViewController {
    
    // MARK: - View Property
    
    private let profileImageView = ContactImageView(width: 200)
    
    private let generateRandomImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // MARK: - Property
    
    private let imageDownloader = ImageDownloader()
    private var editMode: EditMode = .add
    private var contact: Contact?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Configuration
    
    /// AddContactVC에 연락처 정보를 주입하는 함수
    func configureData(with contact: Contact) {
        self.contact = contact
        profileImageView.configure(with: UIImage(data: contact.profileImage ?? Data()))
        nameTextField.text = contact.name
        phoneNumberTextField.text = contact.phoneNumber
        title = contact.name
        editMode = .modify
    }
    
    private func configureNavigationBar() {
        if title == nil {
            title = "연락처 추가"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .done, target: self, action: #selector(didTapAddContactButton))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let subviews = [
            profileImageView,
            generateRandomImageButton,
            nameTextField,
            phoneNumberTextField
        ]
        
        subviews.forEach {
            view.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        generateRandomImageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(generateRandomImageButton.snp.bottom).offset(16)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
        }
    }
    
    private func configureAction() {
        generateRandomImageButton.addTarget(self, action: #selector(didTapGenerateRandomImageButton), for: .touchUpInside)
    }
}

// MARK: - Objc Method

private extension AddContactViewController {
    @objc
    func didTapGenerateRandomImageButton() {
        Task {
            do {
                let image = try await imageDownloader.downloadRandomImage()
                await MainActor.run {
                    profileImageView.configure(with: UIImage(data: image))
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    func didTapAddContactButton() {
        switch editMode {
        case .add:
            CoreDataStack.shared.createData(
                name: nameTextField.text ?? "",
                phoneNumber: phoneNumberTextField.text ?? "",
                profileImage: profileImageView.getImageData() ?? Data()
            )
            
        case .modify:
            guard let contact else { return }
            do {
                try CoreDataStack.shared.updateData(
                    id: contact.id,
                    name: nameTextField.text ?? "",
                    phoneNumber: phoneNumberTextField.text ?? "",
                    profileImage: profileImageView.getImageData() ?? Data()
                )
            } catch {
                print(error.localizedDescription)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

@available(iOS 17, *)
#Preview {
    AddContactViewController()
}
