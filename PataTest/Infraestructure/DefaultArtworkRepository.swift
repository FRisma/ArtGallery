//
//  DefaultArtworkRepository.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import PataNetwork
import Foundation

final class DefaultArtworkRepository {
    private let service: Requester
    private var currentPage: Int = 0
    private var cachedArtworks: [Artwork]?
    
    init(service: Requester = Requester()) {
        self.service = service
    }
}

extension DefaultArtworkRepository: ArtworkRepository {
    func fetchArtrworks(completion: @escaping ArtworkListRepositoryCompletion) {
        let request = ListArtworkResquest(page: .zero)
        cachedOrRemoteArtworks(request: request, completion: completion)
    }
    
    func fetchArtworksNextPage(completion: @escaping ArtworkListRepositoryCompletion) {
        let request = ListArtworkResquest(page: currentPage+1)
        remoteFetchArtowkrs(request: request, completion: completion)
    }
    
    func fetchDetails(forArtIdentifier identifier: Double, completion: @escaping ArtworkDetailsRepositoryCompletion) {
        let request = ListArtworkResquest(page: .zero)
        cachedOrRemoteArtworks(request: request) { result in
            switch result {
            case .success(let artworks):
                completion(.success(artworks.first(where: { $0.id == identifier} )))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension DefaultArtworkRepository {
    func cachedOrRemoteArtworks(request: ListArtworkResquest, completion: @escaping ArtworkListRepositoryCompletion) {
        guard let cachedArtworks = cachedArtworks else {
            remoteFetchArtowkrs(request: request) { result in
                switch result {
                case .success(let artworks):
                    completion(.success(artworks))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            return
        }
        completion(.success(cachedArtworks))
    }
    
    func remoteFetchArtowkrs(request: ListArtworkResquest, completion: @escaping ArtworkListRepositoryCompletion) {
        service.request(request) { [weak self] (result: Result<ListArtworkResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.currentPage = response.pagination.currentPage
                let responseArtworks = response.data
                if self.cachedArtworks == nil {
                    self.cachedArtworks = responseArtworks
                } else {
                    self.cachedArtworks?.append(contentsOf: responseArtworks)
                }
                completion(.success(self.cachedArtworks!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
