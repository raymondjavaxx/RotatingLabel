//
//  SceneDelegate.swift
//  RotatingLabelDemo
//
//  Created by Ramon Torres on 3/16/23.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = DemoViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Not implemented.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Not implemented.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Not implemented.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Not implemented.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Not implemented.
    }

}
