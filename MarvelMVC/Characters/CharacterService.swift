//
//  CharacterService.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 23/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

typealias CharacterServiceCompletion = (_ model: CharacterResponseModel?, _ error: Error?) -> Void

class CharacterService {
    
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchCharacters(completion: @escaping CharacterServiceCompletion) {
        if let url = URL(string: URLs.characters) {
            let request = URLRequest(url: url)
            networkManager.fetch(request: request, completeOnMainThread: false) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let model = try? decoder.decode(CharacterResponseModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(model, error)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func fCharacters(completion: @escaping (_ model: [MarvelCharacter]?, _ error: Error?) -> Void) {
        if let url = URL(string: URLs.characters) {
            let request = URLRequest(url: url)
            networkManager.fetch(request: request, completeOnMainThread: false) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let model = try? decoder.decode(CharacterResponseModel.self, from: data)
                    let characters = model?.data.characters
                    DispatchQueue.main.async {
                        completion(characters, error)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
}
