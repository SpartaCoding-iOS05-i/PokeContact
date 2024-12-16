//
//  AddContactViewController.swift
//  PokeContact
//
//  Created by 권승용 on 12/9/24.
//

import UIKit
import SnapKit

final class AddContactViewController: UIViewController {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
    
    private let imageDownloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureNavigationBar() {
        title = "연락처 추가"
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

private extension AddContactViewController {
    @objc
    func didTapGenerateRandomImageButton() {
        Task {
            do {
                let image = try await imageDownloader.downloadRandomImage()
                await MainActor.run {
                    profileImageView.image = UIImage(data: image)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    func didTapAddContactButton() {
        CoreDataStack.shared.createData(
            name: nameTextField.text ?? "",
            phoneNumber: phoneNumberTextField.text ?? "",
            profileImage: profileImageView.image?.pngData() ?? Data()
        )
        
        navigationController?.popViewController(animated: true)
    }
}

@available(iOS 17, *)
#Preview {
    AddContactViewController()
}
