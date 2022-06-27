//
//  ListCoordinator.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import PataCore
import Foundation
import UIKit

final class ListCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    typealias Dependencies = ListViewControllerFactory & DetailsViewControllerFactory
    private let dependencies: Dependencies
    let rootViewController: UIViewController
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        let initialViewController = dependencies.makeListViewController()
        rootViewController = UINavigationController(rootViewController: initialViewController)
        initialViewController.navigationDelegate = self
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        showListViewController()
    }
    
    private func showListViewController() {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.pushViewController(rootViewController, animated: true)
    }
    
    private func showDetailsViewController(artwork: Artwork) {
        let detailsViewController = dependencies.makeDetailsViewController(artwork: artwork)
        rootViewController.show(detailsViewController, sender: nil)
    }
}

extension ListCoordinator: ListViewControllerNavigationDelegate {
    func didTapItem(_ item: Artwork) {
        showDetailsViewController(artwork: item)
    }
}
