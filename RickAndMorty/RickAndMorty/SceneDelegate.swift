//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let characterListViewController = CharacterListConfigurator.configure()
        let navigationController = UINavigationController(rootViewController: characterListViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
