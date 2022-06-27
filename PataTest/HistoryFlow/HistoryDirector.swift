//
//  HistoryDirector.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import Foundation

protocol HistoryDirectorFactory {
    func makeHisoryDirector() -> HistoryDirector
}

final class HistoryDirector {
    typealias Dependencies = HistoryRepositoryProvider & ImageRepositoryProvider
    private let dependencies: Dependencies
    
    enum Event {
        case viewIsReady
        case attempToSelectAHistoricalItemId(Double)
    }
    
    enum State {
        case initial([ArtworkUIModel])
        case noRecords
        case didSelectIem(Artwork)
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
            let historicalRecords = dependencies.historyRepository.getHitstoryArtworkList()
            guard !historicalRecords.isEmpty else {
                stateListener(.noRecords)
                return
            }
            stateListener(.initial(historicalRecords.reversed().map(map(artworkModelToUIModel:))))
        
        case .attempToSelectAHistoricalItemId(let artId):
            guard let artwork = dependencies.historyRepository.getArtwork(id: artId) else { return }
            stateListener(.didSelectIem(artwork))
        }
    }
    
    private func map(artworkModelToUIModel model: Artwork) -> ArtworkUIModel {
        ArtworkUIModel(id: model.id,
                       title: model.title,
                       image: dependencies.imageRepository.imageFor(imageId: model.imageId, quality: .mid),
                       dateDisplay: model.dateDisplay,
                       artistDisplay: model.artistDisplay)
    }

}
