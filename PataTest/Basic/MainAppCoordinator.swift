//
//  MainAppCoordinator.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import PataCore
import UIKit

final class MainAppCoordinator: NSObject, Coordinator {
    typealias Dependencies = ListCoordinator.Dependencies & HistoryCoordinator.Dependencies
    private let dependencies: Dependencies
    
    var children: [Coordinator] = []
    private let window: UIWindow
    
    private lazy var tabCoordinators: [Coordinator] = {
        [
            ListCoordinator(dependencies: dependencies),
            HistoryCoordinator(dependencies: dependencies)
        ]
    }()
    
    // MARK: - Object Lifecycle

    init(dependencies: Dependencies, window: UIWindow) {
        self.dependencies = dependencies
        self.window = window
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        
        // Init coordinators
        // List
        let listCoordinator = tabCoordinators.first! as! ListCoordinator
        let listRootViewController = listCoordinator.rootViewController
        listRootViewController.tabBarItem = UITabBarItem(title: "Explore",
                                                         image: UIImage(systemName: "paperplane.fill"),
                                                         selectedImage: nil)
        
        // History
        let historyCoordinator = tabCoordinators.last! as! HistoryCoordinator
        let historyRootViewController = historyCoordinator.rootViewController
        historyRootViewController.tabBarItem = UITabBarItem(title: "History",
                                                            image: UIImage(systemName: "square.and.arrow.down"),
                                                            selectedImage: nil)
        
        tabBarController.viewControllers = [listRootViewController, historyRootViewController]
        
        showViewController(tabBarController)
    }
    
    // MARK: - Private methods
    
    private func showViewController(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
