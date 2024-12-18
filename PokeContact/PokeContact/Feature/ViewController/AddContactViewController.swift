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
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.font = .monospacedSystemFont(ofSize: 18, weight: .regular)
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
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
        if editMode == .add {
            generateRandomImage()
        }
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
        phoneNumberTextField.delegate = self
        
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
        generateRandomImage()
    }
    
    @objc
    func didTapAddContactButton() {
        guard checkFieldsAndShowAlert() else {
            return
        }
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

private extension AddContactViewController {
    func generateRandomImage() {
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
    
    func checkFieldsAndShowAlert() -> Bool {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "이름이 비어있습니다!", message: "이름을 입력해주세요")
            return false
        }
        
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            showAlert(title: "전화번호가 비어있습니다!", message: "전화번호를 입력해주세요")
            return false
        }
        
        let refinedPhoneNumber = refinePhoneNumber(phoneNumber)
        
        guard validatePhoneNumber(number: refinedPhoneNumber) else {
            showAlert(title: "올바른 전화번호 양식이 아닙니다.", message: "010-xxxx-xxxx 의 양식으로 입력해 주세요")
            return false
        }
        
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 010-xxxx-xxxx 형태인지 검사
    func validatePhoneNumber(number: String) -> Bool {
        let phoneNumberRegex = /^010[0-9]{8}$/
        guard number.wholeMatch(of: phoneNumberRegex) != nil else {
            return false
        }
        return true
    }
    
    func refinePhoneNumber(_ phoneNumber: String) -> String {
        let newPhoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        return newPhoneNumber
    }
}

extension AddContactViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 새로운 텍스트 검사, 자동으로 하이픈(-) 넣어주고 최대 13자리 넘어갈 경우 입력 제한
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.count > 13 {
                return false
            } else {
                let numericPhoneNumber = updatedText.filter { $0.isNumber }
                textField.text = makePhoneNumberFormatted(numericPhoneNumber)
            }
        }
        return false
    }
    
    // 01011111111 -> 010-1111-1111
    func makePhoneNumberFormatted(_ phoneNumber: String) -> String {
        var stringWithHypen = phoneNumber
        
        if stringWithHypen.count > 3 {
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
        }
        
        if stringWithHypen.count > 8 {
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: 8 - stringWithHypen.count))
        }
        
        return stringWithHypen
    }
}

@available(iOS 17, *)
#Preview {
    AddContactViewController()
}
