//
//  DefaultArtistRepository.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import PataNetwork
import Foundation

final class DefaultArtistRepository {
    private let service: Requester
    
    init(service: Requester = Requester()) {
        self.service = service
    }
}

extension DefaultArtistRepository: ArtistRepository {
    func fetchArtistDetails(_ artistId: Double, completion: @escaping ArtistDetailsCompletion) {
        let request = ArtistDetailsRequest(artistId: artistId)
        service.request(request) { (result:Result<ArtistDetailsResponse, Error>) in
            switch result {
            case .success(let artistResponse):
                completion(.success(artistResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
