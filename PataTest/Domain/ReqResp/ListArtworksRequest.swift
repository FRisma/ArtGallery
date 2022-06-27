//
//  ListArtworksRequest.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import PataNetwork
import Foundation

struct ListArtworkResquest: HTTPRequest {
    var scheme: String = "https"
    var host: String? = "api.artic.edu"
    var path: String = "/api/v1/artworks"
    var parameters: [URLQueryItem]? {
        [
            URLQueryItem(name: "page", value: "\(self.page)"),
            URLQueryItem(name: "limit", value: "15"),
            URLQueryItem(name: "fields", value: "id,title,artist_display,date_display,main_reference_number,artist_id,thumbnail,image_id")
        ]
    }
    var customHost: String? = nil
    var method: HTTPMethod = .get
    var body: HTTPBody = EmptyBody()
    
    private let page: Int
    
    init(page: Int) {
        self.page = page
    }
}
