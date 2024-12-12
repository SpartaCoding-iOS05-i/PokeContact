//
//  NetworkManager.swift
//  PokeContact
//
//  Created by 이명지 on 12/10/24.
//
import UIKit
import Alamofire

final class PokeNetworkManager {
    func fetchRandomPokemon(completion: @escaping (Result<UIImage, Error>) -> Void) {
        let url = "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...1000))"
        
        AF.request(url).responseDecodable(of: PokeResponse.self) { response in
            switch response.result {
            case .success(let pokemon):
                if let spriteUrl = pokemon.sprites.frontDefault,
                   let imageUrl = URL(string: spriteUrl) {
                    
                    AF.request(imageUrl).responseData { imageResponse in
                        switch imageResponse.result {
                        case .success(let imageData):
                            if let image = UIImage(data: imageData) {
                                completion(.success(image))
                            } else {
                                completion(.failure(NetworkError.invalidImageData))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NetworkError.noImageUrl))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
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

enum NetworkError: Error {
    case noImageUrl
    case invalidImageData
}
