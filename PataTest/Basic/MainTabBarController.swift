//
//  TabBarViewController.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import PataCore
import UIKit

protocol MainTabBarControllerFactory: AnyObject {
    func makeMainTabBarController() -> MainTabBarController
}

final class MainTabBarController: UITabBarController {
    typealias Dependencies = Any
    private let dependencies: Dependencies
    
    var tabsViewControllers: [UIViewController] {
        viewControllers ?? []
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(tabViewController: UIViewController, animated: Bool) {
        let tabBarViewControllers = tabsViewControllers + [tabViewController]
        setViewControllers(tabBarViewControllers, animated: animated)
    }
}
