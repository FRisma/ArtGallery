//
//  ArtworkRepository.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation

protocol ArtworkRepositoryProvider {
    var artworkRepository: ArtworkRepository { get }
}

typealias ArtworkListRepositoryCompletion = ((Result<[Artwork], Error>) -> Void)
typealias ArtworkDetailsRepositoryCompletion = ((Result<Artwork?, Error>) -> Void)

protocol ArtworkRepository {
    func fetchArtrworks(completion: @escaping ArtworkListRepositoryCompletion)
    func fetchArtworksNextPage(completion: @escaping ArtworkListRepositoryCompletion)
    func fetchDetails(forArtIdentifier identifier: Double, completion: @escaping ArtworkDetailsRepositoryCompletion)
}
