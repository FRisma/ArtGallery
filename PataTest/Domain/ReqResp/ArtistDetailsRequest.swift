//
//  ArtistDetailsRequest.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import PataNetwork
import Foundation

struct ArtistDetailsRequest: HTTPRequest {
    var scheme: String = "https"
    var host: String? = "api.artic.edu"
    var path: String
    var parameters: [URLQueryItem]? = nil
    var method: HTTPMethod = .get
    var body: HTTPBody = EmptyBody()
    
    init(artistId: Double) {
        self.path = "/api/v1/artists/\(artistId)"
    }
}
