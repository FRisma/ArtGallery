//
//  HTTPRequest.swift
//  
//
//  Created by Franco on 26/06/22.
//

import Foundation

/// Types adopting the `HTTPRequest` protocol can be used to construct URLs, which are then used to construct URL requests.
public protocol HTTPRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var body: HTTPBody { get }
    var parameters: [URLQueryItem]? { get }
    var customHost: String? { get }
    var scheme: String { get }
    var host: String? { get }
}
