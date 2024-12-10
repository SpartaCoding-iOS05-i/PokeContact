//
//  ImageDownloader.swift
//  PokeContact
//
//  Created by 권승용 on 12/10/24.
//

import Foundation

final class ImageDownloader {
    private let session = URLSession.shared
    
    func downloadRandomImage() async throws -> Data {
        let randomNumber = Int.random(in: 1...1000)
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)")
        var data = try await request(with: url!)
        let dto = try JSONDecoder().decode(PokemonInfoDTO.self, from: data)
        let profileImageURL = URL(string: dto.sprites.frontDefault)
        data = try await request(with: profileImageURL!)
        return data
    }
    
    func request(with url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        return data
    }
}
