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
    
    private let profileImage = RoundImageView()
    
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
    
    private var mode: ContactMode
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
        
        generateButton.addTarget(self, action: #selector(didTapGenerate), for: .touchUpInside)
    }
    
    // MARK: - Mode Configuration
    private func configureMode() {
        print("Configuring mode: \(mode)")
        switch mode {
        case .add:
            self.title = "Add Contact"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Save",
                style: .plain,
                target: self,
                action: #selector(didTapCreate))
        case .edit(let contact):
            self.title = "Edit Contact"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Save",
                style: .plain,
                target: self,
                action: #selector(didTapUpdate))
            profileImage.image = UIImage(named: "Star")
            nameTextField.text = contact.fullName
            phoneTextField.text = contact.phoneNumber
        }
    }
    
    // MARK: - Actions
    @objc private func didTapGenerate() {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        let randomColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        )

        let image = renderer.image { context in
            randomColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }

        profileImage.image = image
    }
    
    @objc private func didTapCreate() {
        print("DetailViewController: didTapCreate called.")
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(message: "All fields are required.")
            return
        }

        let contact = Contact(context: viewModel.repository.context)
        contact.fullName = name
        contact.phoneNumber = phone

        do {
            try viewModel.repository.context.save()
            print("DetailViewController: Contact saved in context.")
        } catch {
            print("DetailViewController: Failed to save context. Error: \(error)")
            showAlert(message: "Failed to save contact. Please try again.")
            return
        }

        onSave?(contact)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapUpdate() {
        print("didTapUpdate called")
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(message: "All fields are required.")
            return
        }
        
        if case .edit(let contact) = mode {
            contact.fullName = name
            contact.phoneNumber = phone
            onSave?(contact)
            print("Saved")
        }
        
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helpers
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}

extension DetailViewController: DetailViewModelDelegate {
    func didSaveContact() {
        print("Contact saved successfully.")
    }
    
    func didFailWithError(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
}
