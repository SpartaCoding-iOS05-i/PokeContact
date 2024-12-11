//
//  ImageLoader.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-11.
//

import UIKit

class ImageLoader {
    /// Loads an image from the given URL and passes it to the completion handler.
    static func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            print("ImageLoader: Invalid URL: \(url)")
            completion(nil)
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    print("ImageLoader: Failed to create UIImage from data")
                    completion(nil)
                }
            } catch {
                print("ImageLoader: Failed to load image from URL: \(error)")
                completion(nil)
            }
        }
    }
}
