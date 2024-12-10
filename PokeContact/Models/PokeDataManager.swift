//
//  PokeDataManager.swift
//  PokeContact
//
//  Created by 이명지 on 12/10/24.
//
import UIKit
import Alamofire

final class PokeDataManager {
    
}

struct PokeResponse: Decodable {
    let sprites: Sprites
    
    struct Sprites: Decodable {
        let frontDefault: String?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}
