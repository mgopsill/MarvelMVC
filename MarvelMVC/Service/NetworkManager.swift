//
//  NetworkManager.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 25/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

typealias ServiceCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkManaging {
    @discardableResult func fetch(request: URLRequest, completeOnMainThread: Bool, completion: @escaping ServiceCompletion) -> URLSessionDataTaskProtocol
}

class NetworkManager: NetworkManaging {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult func fetch(request: URLRequest, completeOnMainThread: Bool, completion: @escaping ServiceCompletion) -> URLSessionDataTaskProtocol {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if completeOnMainThread {
                DispatchQueue.main.async {
                    completion(data, response, error)
                }
            } else {
                completion(data, response, error)
            }
        }
        dataTask.resume()
        return dataTask
    }
}
