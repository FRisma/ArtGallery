//
//  HistoryRepository.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation

protocol HistoryRepositoryProvider {
    var historyRepository: HistoryRepository { get }
}

protocol HistoryRepository {
    func getLastSeenArtwork() -> Artwork?
    func getArtwork(id: Double) -> Artwork?
    func getHitstoryArtworkList() -> [Artwork]
    func append(artwork: Artwork)
}
