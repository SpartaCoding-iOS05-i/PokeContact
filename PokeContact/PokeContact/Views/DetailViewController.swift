//
//  DetailViewController.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-09.
//

import UIKit
import SnapKit
import Then

enum ContactMode {
    case add
    case edit(contact: Contact)
}

class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private var mode: ContactMode
    private var currentImageURL: String = ""
    
    private let profileImage = RoundImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let generateButton = UIButton().then {
        $0.setTitle("Generate Avatar", for: .normal)
        $0.setTitleColor(.systemGray4, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let nameTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Name"
        $0.keyboardType = .namePhonePad
    }
    
    private let phoneTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Phone Number"
        $0.keyboardType = .phonePad
    }
    
    var onSave: ((Contact) -> Void)?
    
    // MARK: - Initialization
    init(viewModel: DetailViewModel, mode: ContactMode) {
        self.viewModel = viewModel
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMode()
        viewModel.delegate = self
        onSave = viewModel.onSave
        print("DetailViewController: onSave is \(onSave == nil ? "nil" : "set")")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        [
            profileImage,
            generateButton,
            nameTextField,
            phoneTextField,
        ].forEach { self.view.addSubview($0) }
        
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.42)
            make.height.equalTo(profileImage.snp.width)
            make.top.equalToSuperview().offset(120)
        }
        
        generateButton.snp.makeConstraints { make in
            make.centerX.equalTo(profileImage)
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.top.equalTo(profileImage.snp.bottom)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(35)
            make.height.equalTo(44)
            make.top.equalTo(generateButton.snp.bottom).offset(15)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(44)
            make.top.equalTo(nameTextField.snp.bottom).offset(15)
        }
        
        generateButton.addTarget(self, action: #selector(didTapGenerateAvatar), for: .touchUpInside)
    }
    
    // MARK: - Mode Configuration
    private func configureMode() {
        print("Configuring mode: \(mode)")
        switch mode {
        case .add:
            self.title = "Add Contact"
            
            self.didTapGenerateAvatar()
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Save",
                style: .plain,
                target: self,
                action: #selector(didTapCreate)
            )
        case .edit(let contact):
            self.title = contact.fullName
            
            if let profileImageURL = contact.profileImage {
                currentImageURL = profileImageURL
                loadProfileImage(from: profileImageURL)
            } else {
                print("DetailViewController: No existing profile image URL.")
            }
            
            nameTextField.text = contact.fullName
            phoneTextField.text = contact.phoneNumber
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Save",
                style: .plain,
                target: self,
                action: #selector(didTapUpdate)
            )
        }
    }
    
    // MARK: - Actions
    @objc private func didTapGenerateAvatar() {
        print("DetailViewController: didTapGenerate called")
        
        Task {
            do {
                let spriteURL = try await viewModel.fetchRandomImage()
                print("DetailViewController: Fetched Sprite URL: \(spriteURL)")
                self.updateProfileImage(with: spriteURL)
                self.currentImageURL = spriteURL
            } catch {
                print("DetailViewController: Failed to fetch Sprite URL: \(error)")
                self.showAlert(message: "Failed to fetch Pokémon image. Please try again.")
            }
        }
    }
    
    @objc private func didTapCreate() {
        print("DetailViewController: didTapCreate called.")
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(message: "All fields are required.")
            return
        }

        let imageURL = currentImageURL

        do {
            try viewModel.addContact(name: name, phone: phone, imageURL: imageURL)
            print("DetailViewController: Contact added successfully.")
        } catch {
            print("DetailViewController: Failed to add contact: \(error.localizedDescription)")
            showAlert(message: "Failed to add contact. Please try again.")
        }
    }
    
    @objc private func didTapUpdate() {
        print("DetailViewController: didTapUpdate called.")
        
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(message: "All fields are required.")
            return
        }
        
        guard case .edit(let contact) = mode else { return }
        
        let imageURL = currentImageURL
        
        viewModel.updateContact(contact, withName: name, phone: phone, imageURL: imageURL)
    }


    // MARK: - Helpers
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func updateProfileImage(with url: String) {
        guard let imageURL = URL(string: url) else {
            print("DetailViewController: Invalid URL: \(url)")
            showAlert(message: "Failed to load Pokémon image. Invalid URL.")
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.profileImage.image = image
                    self?.currentImageURL = url // 실시간으로 URL 업데이트
                    print("DetailViewController: Profile image updated.")
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    print("DetailViewController: Failed to load image data.")
                    self?.showAlert(message: "Failed to load Pokémon image.")
                }
            }
        }
    }

    private func loadProfileImage(from url: String) {
        ImageLoader.loadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.profileImage.image = image
            } else {
                print("DetailViewController: Failed to load image.")
            }
        }
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func didSaveContact() {
        print("DetailViewController: Contact saved successfully..")
    }
    
    func didFailWithError(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
}
