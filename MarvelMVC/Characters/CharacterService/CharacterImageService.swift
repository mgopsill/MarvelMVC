//
//  CharacterImageService.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 25/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CharacterImageService: ImageService {
    
    private let networkManager: NetworkManaging
    private let imageCache: ImageCacher
    
    init(networkManager: NetworkManaging = NetworkManager(),
         imageCache: ImageCacher = ImageCache.shared) {
        self.networkManager = networkManager
        self.imageCache = imageCache
    }
    
    func fetchImage(request: URLRequest, completion: @escaping ImageServiceCompletion) {
        if let image = cachedImage(for: request) {
            completion(image, nil)
        } else {
            networkManager.fetch(request: request, completeOnMainThread: false) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    self.cache(image: image, request: request)
                    DispatchQueue.main.async {
                        completion(image, error)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    private func cachedImage(for request: URLRequest) -> UIImage? {
        if let url = request.url {
            return imageCache.loadImage(for: url)
        } else {
            return nil
        }
    }
    
    private func cache(image: UIImage?, request: URLRequest) {
        guard let image = image, let url = request.url else { return }
        imageCache.cache(image, for: url)
    }
}
