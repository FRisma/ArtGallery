//
//  SceneDelegate.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let appDependencies = MainDependencyContainer()
    
    private lazy var appCoordinator: MainAppCoordinator = {
        guard let window = window else {
            fatalError("An app should always have a window. If there isn't, something is terrible wrong.")
        }

        return makeAppCoordinator(forWindow: window)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        buildWindow(from: scene)

        appCoordinator.present(animated: false, onDismissed: nil)
    }
}

private extension SceneDelegate {
    func buildWindow(from scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.overrideUserInterfaceStyle = .light
    }

    func makeAppCoordinator(forWindow window: UIWindow) -> MainAppCoordinator {
        return MainAppCoordinator(dependencies: appDependencies, window: window)
    }
}
