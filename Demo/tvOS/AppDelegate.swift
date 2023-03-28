//
//  AppDelegate.swift
//  tvOS
//
//  Created by Ramon Torres on 3/28/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow()
        self.window?.rootViewController = DemoViewController()
        self.window?.makeKeyAndVisible()
        return true
    }

}
