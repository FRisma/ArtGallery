//
//  DefaultHistoryRepository.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation

final class DefaultHistoryRepository {
    typealias Dependencies = Any
    private let dependencies: Dependencies
    
    private var historyList: [Artwork] = []
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DefaultHistoryRepository: HistoryRepository {
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
        historyList.removeAll(where: { artwork.id == $0.id })
        historyList.append(artwork)
    }
}
