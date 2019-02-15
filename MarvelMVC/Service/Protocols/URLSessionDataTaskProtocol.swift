//
//  URLSessionDataTaskProtocol.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 25/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
