//
//  MainDependencyContainer.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation

final class MainDependencyContainer {
    
    // MARK: - ArtworkRepositoryProvider
    
    lazy var artworkRepository: ArtworkRepository = {
        DefaultArtworkRepository()
    }()
    
    // MARK: - HistoryRepositoryProvider
    
    lazy var historyRepository: HistoryRepository = {
        return DefaultNonPersistentHistoryRepository()
        // The following repository makes use of Realm and it's disabled because it throws an exception regarding threads
        // return DefaultHistoryRepository()
    }()
    
    // MARK: - ImageRepositoryProvider
    
    lazy var imageRepository: ImageRepository = {
        ArticImageRepository()
    }()
    
    // MARK: - ArtistRepositoryProvider
    
    lazy var artistRepository: ArtistRepository = {
        DefaultArtistRepository()
    }()
}

// MARK: - ListViewControllerFactory

extension MainDependencyContainer: ListViewControllerFactory {
    func makeListViewController() -> ListViewController {
        let director = makeListDirector()
        let viewModelFactory = makeListViewModelFactory()
        return ListViewController(director: director, viewModelFactory: viewModelFactory)
    }
}

// MARK: - ListDirectorFactory

extension MainDependencyContainer: ListDirectorFactory {
    func makeListDirector() -> ListDirector {
        ListDirector(dependencies: self, stateUpdate: { _ in })
    }
}


// MARK: - ListViewModelFactorBuilder

extension MainDependencyContainer: ListViewModelFactorBuilder {
    func makeListViewModelFactory() -> ListViewModelFactory {
        ListViewModelFactory()
    }
}

// MARK: - DetailsViewControllerFactory

extension MainDependencyContainer: DetailsViewControllerFactory {
    func makeDetailsViewController(artwork: Artwork) -> DetailsViewController {
        let director = makeDetailsDirector(artwork: artwork)
        let viewModelFactory = DetailsViewModelFactory()
        return DetailsViewController(director: director, viewModelFactory: viewModelFactory)
    }
}

// MARK: - DetailsDirectorFactory {

extension MainDependencyContainer: DetailsDirectorFactory {
    func makeDetailsDirector(artwork: Artwork) -> DetailsDirector {
        DetailsDirector(dependencies: self, stateUpdate: { _ in }, artwork: artwork)
    }
}

// MARK: - HistoryViewControllerFactory

extension MainDependencyContainer: HistoryViewControllerFactory {
    func makeHistoryViewController() -> HistoryViewController {
        let director = makeHisoryDirector()
        return HistoryViewController(director: director)
    }
}

// MARK: - HistoryDirectorFactory

extension MainDependencyContainer: HistoryDirectorFactory {
    func makeHisoryDirector() -> HistoryDirector {
        HistoryDirector(dependencies: self, stateUpdate: { _ in })
    }
}

extension MainDependencyContainer: ArtworkRepositoryProvider {}
extension MainDependencyContainer: HistoryRepositoryProvider {}
extension MainDependencyContainer: ImageRepositoryProvider {}
extension MainDependencyContainer: ArtistRepositoryProvider {}
