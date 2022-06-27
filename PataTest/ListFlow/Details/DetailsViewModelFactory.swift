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
        case .initial:
            return nil
        case .didFetchExtraInfo(_):
            return nil
        }
    }
}
