//
//  ListDirector.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import PataCore
import Foundation

protocol ListDirectorFactory {
    func makeListDirector() -> ListDirector
}

final class ListDirector {
    typealias Dependencies = ArtworkRepositoryProvider & HistoryRepositoryProvider & ImageRepositoryProvider
    private let dependencies: Dependencies
    
    enum Event {
        case viewIsReady
        case attemptToSeeNextBatch
        case attemptSelection(artId: Double)
    }
    
    enum State {
        case didFetchItems(items: [ArtworkUIModel], lastSeenItem: ArtworkUIModel?)
        case didSelectArtwork(Artwork)
        case error(String)
    }
    typealias StateUpdate = (State) -> Void
    var stateListener: StateUpdate
    
    init(dependencies: Dependencies, stateUpdate: @escaping StateUpdate) {
        self.dependencies = dependencies
        self.stateListener = stateUpdate
    }
    
    func handleEvent(_ event: Event) {
        switch event {
        case .viewIsReady:
            fetchArtworks()
        case .attemptToSeeNextBatch:
            fetchNextArtworks()
        case .attemptSelection(let artId):
            dependencies.artworkRepository.fetchDetails(forArtIdentifier: artId) { [weak self] result in
                switch result {
                case .success(let artwork):
                    guard let artwork = artwork else { return }
                    self?.dependencies.historyRepository.append(artwork: artwork)
                    self?.stateListener(.didSelectArtwork(artwork))
                case .failure(let error):
                    self?.stateListener(.error(error.localizedDescription))
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func fetchArtworks() {
        dependencies.artworkRepository.fetchArtrworks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let artworks):
                let lastSeenArtwork = self.dependencies.historyRepository.getLastSeenArtwork()
                var lastSeenUIModel: ArtworkUIModel? = nil
                if let lastSeenArtwork = lastSeenArtwork {
                    lastSeenUIModel = self.map(artworkModelToUIModel: lastSeenArtwork)
                }
                
                self.stateListener(.didFetchItems(items: artworks.map(self.map(artworkModelToUIModel:)),
                                                  lastSeenItem: lastSeenUIModel))
            case .failure(let error):
                self.stateListener(.error(error.localizedDescription))
            }
        }
    }
    
    private func fetchNextArtworks() {
        dependencies.artworkRepository.fetchArtworksNextPage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let artworks):
                self.stateListener(.didFetchItems(items: artworks.map(self.map(artworkModelToUIModel:)),
                                                  lastSeenItem: nil))
            case .failure(let error):
                self.stateListener(.error(error.localizedDescription))
            }
        }
    }
    
    private func map(artworkModelToUIModel model: Artwork) -> ArtworkUIModel {
        ArtworkUIModel(id: model.id,
                       title: model.title,
                       image: dependencies.imageRepository.imageFor(imageId: model.imageId, quality: .low),
                       dateDisplay: model.dateDisplay,
                       artistDisplay: model.artistDisplay)
    }
}
