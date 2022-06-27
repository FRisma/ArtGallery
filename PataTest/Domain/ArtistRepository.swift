//
//  ArtistRepository.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import Foundation

protocol ArtistRepositoryProvider {
    var artistRepository: ArtistRepository { get }
}

typealias ArtistDetailsCompletion = (Result<Artist,Error>) -> Void

protocol ArtistRepository {
    func fetchArtistDetails(_ artistId: Double, completion: @escaping ArtistDetailsCompletion)
}
