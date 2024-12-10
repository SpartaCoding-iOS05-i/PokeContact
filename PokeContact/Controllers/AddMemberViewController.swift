//
//  AddMemberViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit
import CoreData

final class AddMemberViewController: UIViewController {
    private let addMemberView = AddMemberView()
    private let networkManager = NetworkManager()
    private let pokeDataManager = PokeDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addMemberView
        addMemberView.delegate = self
        configureNavigationBar()
        configurePokeProfile()
    }
    
    private func configureNavigationBar() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(completeButtonTapped))
    }
    
    private func configurePokeProfile() {
        networkManager.fetchRandomPokemon { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    self?.addMemberView.configureProfileImage(image: image)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func completeButtonTapped() {
        let image = addMemberView.profileImageView.image?.toString() ?? ""
        let name = addMemberView.nameTextField.text ?? ""
        let phoneNumber = addMemberView.phoneNumberTextField.text ?? ""
        pokeDataManager.createMember(profileImage: image, name: name, phoneNumber: phoneNumber)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddMemberViewController: RandomImageButtonDelegate {
    func changeRandomImage() {
        self.configurePokeProfile()
    }
}

extension UIImage {
    func toString() -> String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}
