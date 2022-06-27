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
        DefaultHistoryRepository(dependencies: self)
    }()
    
    // MARK: - ImageRepositoryProvider
    
    lazy var imageRepository: ImageRepository = {
        ArticImageRepository()
    }()
}

// MARK: - MainTabBarControllerFactory

extension MainDependencyContainer: MainTabBarControllerFactory {
    func makeMainTabBarController() -> MainTabBarController {
        MainTabBarController(dependencies: self)
    }
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
        return DetailsViewController(director: director)
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
