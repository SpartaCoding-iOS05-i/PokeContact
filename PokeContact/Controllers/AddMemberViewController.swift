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
    private var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addMemberView
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(completeButtonTapped))
    }
    
    @objc private func completeButtonTapped() {
        let image = addMemberView.profileImageView.image?.toString() ?? ""
        let name = addMemberView.nameTextField.text ?? ""
        let phoneNumber = addMemberView.phoneNumberTextField.text ?? ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        createMember(profileImage: image, name: name, phoneNumber: phoneNumber)
    }
    
    private func createMember(profileImage: String, name: String, phoneNumber: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: PokeContactBook.className, in: self.container.viewContext) else { return }
        
        let newPoke = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPoke.setValue(profileImage, forKey: PokeContactBook.Key.profileImage)
        newPoke.setValue(name, forKey: PokeContactBook.Key.name)
        newPoke.setValue(phoneNumber, forKey: PokeContactBook.Key.phoneNumber)
        
        do {
            try self.container.viewContext.save()
            print("context save 성공")
        } catch {
            print("context svae 실패")
        }
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
