//
//  HistoryCoordinator.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import PataCore
import Foundation
import UIKit

final class HistoryCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    typealias Dependencies = HistoryViewControllerFactory & DetailsViewControllerFactory
    private let dependencies: Dependencies
    let rootViewController: UIViewController
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        let initialViewController = dependencies.makeHistoryViewController()
        rootViewController = UINavigationController(rootViewController: initialViewController)
        initialViewController.navigationDelegate = self
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        showHistoryViewController()
    }
    
    private func showHistoryViewController() {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.pushViewController(rootViewController, animated: true)
    }
    
    private func showDetailsViewController(artwork: Artwork) {
        let detailsViewController = dependencies.makeDetailsViewController(artwork: artwork)
        rootViewController.show(detailsViewController, sender: nil)
    }
}

extension HistoryCoordinator: HistoryViewControllerNavigationDelegate {
    func didTapItem(_ item: Artwork) {
        showDetailsViewController(artwork: item)
    }
}

