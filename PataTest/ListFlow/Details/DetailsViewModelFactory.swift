//
//  DetailsViewModelFactory.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation

struct DetailsViewModelFactory {
    typealias ViewModel = DetailsView.ViewModel
    func makeViewModelFrom(_ state: DetailsDirector.State, previousViewModel: ViewModel?) -> ViewModel? {
        switch state {
        case .initial(let model, let hasArtistInfo):
            return DetailsView.ViewModel(image: model.image,
                                         title: model.title,
                                         artist: model.artistDisplay,
                                         isMoreInfoEnabled: hasArtistInfo,
                                         artistDetails: nil)
        case .didFetchExtraInfo(let artistInfo):
            guard let previousViewModel = previousViewModel else { return nil }
            return  DetailsView.ViewModel(image: previousViewModel.image,
                                          title: previousViewModel.title,
                                          artist: previousViewModel.artist,
                                          isMoreInfoEnabled: previousViewModel.isMoreInfoEnabled,
                                          artistDetails: artistInfo)
        }
    }
}
