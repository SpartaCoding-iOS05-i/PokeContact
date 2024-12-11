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

struct UserInput {
    let name: String
    let phoneNumber: String
}

protocol InputValidatorProtocol: AnyObject {
    func validate(_ input: UserInput) throws
}

final class InputValidator {
    
}
