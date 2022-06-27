//
//  ListArtworksResponse.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation

struct ListArtworkResponse: Decodable {
    let pagination: PaginationConfiguration
    let data: [Artwork]
    
    struct PaginationConfiguration: Decodable {
        let total: Double
        let limit: Int
        let offset: Int
        let totalPages: Int
        let currentPage: Int
        let nextUrl: URL
    }
}
