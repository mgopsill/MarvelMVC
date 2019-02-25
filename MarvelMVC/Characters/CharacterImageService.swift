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
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // TODO: Cache images
    @discardableResult func fetchImage(request: URLRequest, completion: @escaping ImageServiceCompletion) -> URLSessionDataTaskProtocol {
        return networkManager.fetch(request: request, completeOnMainThread: false) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}
