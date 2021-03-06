//
//  SceneDelegate.swift
//  Dolphin
//
//  Created by Иван Медведев on 06.10.2020.
//

import UIKit
import KeychainSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
	var window: UIWindow?

	func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		guard let window = window else { return }
		window.windowScene = windowScene
		let factory = Factory(window: window)
		if KeychainSwift().get("token") != nil {
			factory.createChatTabBarController()
		}
		else {
			factory.createAuthNavigationController()
		}
		window.makeKeyAndVisible()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
	}

	func sceneWillResignActive(_ scene: UIScene) {
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
	}
}
