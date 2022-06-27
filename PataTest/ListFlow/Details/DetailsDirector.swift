//
//  DetailsDirector.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation

protocol DetailsDirectorFactory {
    func makeDetailsDirector(artwork: Artwork) -> DetailsDirector
}

final class DetailsDirector {
    typealias Dependencies = ArtworkRepositoryProvider & ImageRepositoryProvider & ArtistRepositoryProvider
    private let dependencies: Dependencies
    
    enum Event {
        case viewIsReady
        case moreInfo
    }
    
    enum State {
        case initial(ArtworkUIModel)
        case didFetchExtraInfo(Artist)
    }
    typealias StateUpdate = (State) -> Void
    var stateListener: StateUpdate
    private let artwork: Artwork
    
    init(dependencies: Dependencies, stateUpdate: @escaping StateUpdate, artwork: Artwork) {
        self.dependencies = dependencies
        self.stateListener = stateUpdate
        self.artwork = artwork
    }
    
    func handleEvent(_ event: Event) {
        switch event {
        case .viewIsReady:
            stateListener(.initial(ArtworkUIModel(
                id: artwork.id,
                title: artwork.title,
                image: dependencies.imageRepository.imageFor(imageId: artwork.imageId, quality: .high),
                dateDisplay: artwork.dateDisplay,
                artistDisplay: artwork.artistDisplay)))
        case .moreInfo:
            fetchMoreInfo()
        }
    }
    
    private func fetchMoreInfo() {
        guard let artistId = artwork.artistId else { return }
        dependencies.artistRepository.fetchArtistDetails(artistId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let artist):
                self.stateListener(.didFetchExtraInfo(artist))
            case .failure(let error):
                break // Do nothing
            }
        }
    }
}
