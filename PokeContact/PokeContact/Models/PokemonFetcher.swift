//
//  PokemonFetcher.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-11.
//

import Alamofire

class PokemonFetcher {
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"

    /// Fetches a random Pokémon sprite URL synchronously-like.
    func fetchRandomPokemonSpriteURL() async throws -> String {
        let randomID = Int.random(in: 1...1025)
        let url = "\(baseURL)/\(randomID)"

        print("PokemonFetcher: Fetching Pokémon data from URL: \(url)")

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url).responseDecodable(of: PokemonResponse.self) { response in
                switch response.result {
                case .success(let pokemonData):
                    let spriteURL = pokemonData.sprites.front_default
                    print("PokemonFetcher: Successfully fetched sprite URL: \(spriteURL)")
                    continuation.resume(returning: spriteURL)

                case .failure(let error):
                    print("PokemonFetcher: Failed to fetch Pokémon data: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

