//
//  InputValidator.swift
//  PokeContact
//
//  Created by 이명지 on 12/11/24.
//
import UIKit

enum ValidationError: LocalizedError {
    case emptyName
    case emptyPhoneNumber
    case invalidPhoneNumber
    
    var errorMessage: String {
        switch self {
        case .emptyName:
            return "이름을 입력해주세요"
        case .emptyPhoneNumber:
            return "전화번호를 입력해주세요"
        case .invalidPhoneNumber:
            return "올바른 전화번호를 입력해주세요"
        }
    }
}

protocol InputValidatorProtocol: AnyObject {
    func validate(_ input: Contact) throws
}

final class InputValidator: InputValidatorProtocol {
    func validate(_ input: Contact) throws {
        try validateName(input.name)
        try validatePhoneNumber(input.phoneNumber)
    }
    
    private func validateName(_ name: String) throws {
        if name.isEmpty { throw ValidationError.emptyName }
    }
    
    private func validatePhoneNumber(_ phoneNumber: String) throws {
        if phoneNumber.isEmpty { throw ValidationError.emptyPhoneNumber }
        if phoneNumber.count != 13 { throw ValidationError.invalidPhoneNumber }
    }
}
