//
//  ContactViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit

final class ContactViewController: UIViewController {
    // MARK: - Properties
    private var contactView: ContactView?
    private let pokeNetworkManager = PokeNetworkManager()
    private let pokeContactManager = PokeContactManager()
    private var oldName: String?
    
    // MARK: - Initializer
    init() {
        self.contactView = ContactView()
        super.init(nibName: nil, bundle: nil)
        self.configureNavigationBar(title: "연락처 추가")
        self.fetchRandomImage()
    }
    
    init(_ contact: Contact) {
        self.oldName = contact.name
        self.contactView = ContactView(contact)
        super.init(nibName: nil, bundle: nil)
        self.configureNavigationBar(title: contact.name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Functions
    private func setupView() {
        view = contactView
        contactView?.delegate = self
    }
    
    private func configureNavigationBar(title: String) {
        self.navigationItem.title = title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(completeButtonTapped))
    }
    
    private func updateProfileImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.contactView?.configureProfileImage(image: image)
        }
    }
    
    @objc private func completeButtonTapped() {
        guard let contact = createContact() else { return }
        do {
            try validateContact(contact)
            savePokeContact(contact)
            self.navigationController?.popViewController(animated: true)
        } catch let error as ValidationError {
            showAlert(title: error.errorMessage)
        } catch {
            showAlert(title: "오류 발생")
        }
    }
    
    private func createContact() -> Contact? {
        guard let name = contactView?.nameTextField.text,
              let phoneNumber = contactView?.phoneNumberTextField.text,
              let profileImage = contactView?.profileImageView.image?.toString() else {
            return nil
        }
        
        return Contact(name: name,
                       phoneNumber: phoneNumber,
                       profileImage: profileImage)
    }
    
    private func validateContact(_ contact: Contact) throws {
        let inputValidator = InputValidator()
        let contact = Contact(name: contact.name,
                                phoneNumber: contact.phoneNumber,
                                profileImage: contact.profileImage)
        try inputValidator.validate(contact)
    }
    
    private func savePokeContact(_ contact: Contact) {
        if let oldName = self.oldName {
            pokeContactManager.updateContact(currentName: oldName,
                                         updateProfileImage: contact.profileImage,
                                         updateName: contact.name,
                                         updatePhoneNumber: contact.phoneNumber)
        } else {
            pokeContactManager.createContact(profileImage: contact.profileImage,
                                         name: contact.name,
                                         phoneNumber: contact.phoneNumber)
        }
    }
}

// MARK: - Network Methods
extension ContactViewController {
    private func fetchRandomImage() {
        pokeNetworkManager.fetchRandomPokemon { [weak self] result in
            switch result {
            case .success(let image):
                self?.updateProfileImage(image)
            case .failure:
                self?.showAlert(title: "프로필 이미지 로드 실패")
            }
        }
    }
}

// MARK: - Alert Method
extension ContactViewController {
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let success  = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(success)

        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - RandomImageButtonDelegate
extension ContactViewController: ContactViewDelegate {
    func changeRandomImage() {
        self.fetchRandomImage()
    }
}

// MARK: - UIImage -> String? Type Convert
extension UIImage {
    func toString() -> String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}
