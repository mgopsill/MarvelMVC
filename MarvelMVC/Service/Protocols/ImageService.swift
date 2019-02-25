//
//  ImageService.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 25/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

typealias ImageServiceCompletion = (_ image: UIImage?, _ error: Error?) -> Void

protocol ImageService {
    @discardableResult func fetchImage(request: URLRequest, completion: @escaping ImageServiceCompletion) -> URLSessionDataTaskProtocol
}
