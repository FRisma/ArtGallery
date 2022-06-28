//
//  DefaultNonPersistentHistoryRepository.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import Foundation

final class DefaultNonPersistentHistoryRepository {
    private var historyList: [Artwork] = []
}

extension DefaultNonPersistentHistoryRepository: HistoryRepository {
    func getArtwork(id: Double) -> Artwork? {
        historyList.first(where: { $0.id == id })
    }
    
    func getLastSeenArtwork() -> Artwork? {
        historyList.last
    }
    
    func getHitstoryArtworkList() -> [Artwork] {
        historyList
    }
    
    func append(artwork: Artwork) {
        historyList.removeAll(where: { $0.id == artwork.id })
        historyList.append(artwork)
    }
}
