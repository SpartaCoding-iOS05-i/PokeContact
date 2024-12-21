//
//  PokemonResponse.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-11.
//

import Foundation

struct PokemonResponse: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
}

struct Sprites: Decodable {
    let front_default: String
}
