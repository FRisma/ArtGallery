//
//  ListViewModelFactory.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation

protocol ListViewModelFactorBuilder {
    func makeListViewModelFactory() -> ListViewModelFactory
}

struct ListViewModelFactory {
    typealias ViewModel = ListView.ViewModel
    func makeViewModelFrom(_ state: ListDirector.State, previousViewModel: ViewModel?) -> ViewModel? {
        switch state {
        case .didFetchItems(let artworks, let lastSeenArtwork):
            return ViewModel(items: artworks,
                             lastSeen: lastSeenArtwork)
        case .error:
            return previousViewModel
        case .didSelectArtwork:
            return previousViewModel
        }
    }
}
