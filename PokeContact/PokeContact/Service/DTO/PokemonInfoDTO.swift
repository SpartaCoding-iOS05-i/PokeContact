//
//  PokemonInfoDTO.swift
//  PokeContact
//
//  Created by 권승용 on 12/10/24.
//

struct PokemonInfoDTO: Decodable {
    let sprites: SpritesDTO
}

struct SpritesDTO: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
