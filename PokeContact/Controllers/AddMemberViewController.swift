//
//  AddMemberViewController.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit

final class AddMemberViewController: UIViewController {
    private var addMemberView: AddMemberView?
    private let networkManager = NetworkManager()
    private let pokeDataManager = PokeDataManager()
    
    init() {
        self.addMemberView = AddMemberView()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(profileImage: String, name: String, phoneNumber: String) {
        self.addMemberView = AddMemberView(profileImage: profileImage, name: name, phoneNumber: phoneNumber)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addMemberView
        addMemberView?.delegate = self
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(completeButtonTapped))
    }
    
    func configurePokeProfile() {
        networkManager.fetchRandomPokemon { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    self?.addMemberView?.configureProfileImage(image: image)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func completeButtonTapped() {
        let image = addMemberView?.profileImageView.image?.toString() ?? ""
        let name = addMemberView?.nameTextField.text ?? ""
        let phoneNumber = addMemberView?.phoneNumberTextField.text ?? ""
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
