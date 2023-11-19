//
//  SceneDelegate.swift
//  MutilModule
//
//  Created by NguyenHao on 22/10/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let homeViewController = HomeWireframe.createHomeModule()
        homeViewController.view.frame = UIScreen.main.bounds
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
    }
}
