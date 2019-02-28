//
//  CharacterService.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 23/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

typealias CharacterServiceCompletion = (_ result: Result<CharacterResponseModel>) -> Void

enum CharacterServiceError: Error {
    case problem
}

class CharacterService {
    
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchCharacters(completion: @escaping CharacterServiceCompletion) {
        if let url = URL(string: URLs.characters) {
            let request = URLRequest(url: url)
            networkManager.fetch(request: request, completeOnMainThread: false) { [weak self] (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let model = try? decoder.decode(CharacterResponseModel.self, from: data)
                    if let model = model {
                        DispatchQueue.main.async {
                            completion(Result.success(model))
                        }
                    } else {
                        self?.fail(completion)
                    }
                } else {
                    self?.fail(completion)
                }
            }
        }
    }
    
    private func fail(_ completion: @escaping CharacterServiceCompletion) {
        completion(Result.failure(CharacterServiceError.problem))
    }
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

extension Result {
    func resolve() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
