//
//  AddMemberViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit

final class ContactViewController: UIViewController {
    // MARK: - Properties
    private var contactView: ContactView?
    private let networkManager = NetworkManager()
    private let pokeDataManager = PokeDataManager()
    private var oldName: String?
    
    // MARK: - Initializer
    init() {
        self.contactView = ContactView()
        super.init(nibName: nil, bundle: nil)
        self.configureNavigationBar(title: "연락처 추가")
    }
    
    init(profileImage: String, name: String, phoneNumber: String) {
        self.oldName = name
        self.contactView = ContactView(profileImage: profileImage,
                                           name: name,
                                           phoneNumber: phoneNumber)
        super.init(nibName: nil, bundle: nil)
        self.configureNavigationBar(title: name)
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
        self.fetchRandomImage()
    }
    
    private func configureNavigationBar(title: String) {
        self.navigationItem.title = title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(completeButtonTapped))
    }
    
    private func updateProfileImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.contactView?.configureProfileImage(image: image)
        }
    }
    
    @objc private func completeButtonTapped() {
        let inputValidator = InputValidator()
        
        let contact = Contact(name: contactView?.nameTextField.text ?? "",
                                  phoneNumber: contactView?.phoneNumberTextField.text ?? "",
                                  profileImage: contactView?.profileImageView.image?.toString() ?? "")
        do {
            try inputValidator.validate(contact)
            savePokeContact(contact)
            self.navigationController?.popViewController(animated: true)
        } catch let error as ValidationError {
            showAlert(title: error.errorMessage)
        } catch {
            showAlert(title: "오류 발생")
        }
    }
    
    private func savePokeContact(_ contact: Contact) {
        if let oldName = self.oldName {
            pokeDataManager.updateMember(currentName: oldName,
                                         updateProfileImage: contact.profileImage,
                                         updateName: contact.name,
                                         updatePhoneNumber: contact.phoneNumber)
        } else {
            pokeDataManager.createMember(profileImage: contact.profileImage,
                                         name: contact.name,
                                         phoneNumber: contact.phoneNumber)
        }
    }
}

// MARK: - Network Methods
extension ContactViewController {
    private func fetchRandomImage() {
        networkManager.fetchRandomPokemon { [weak self] result in
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
extension ContactViewController: RandomImageButtonDelegate {
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
