//
//  SceneDelegate.swift
//  Dolphin
//
//  Created by Иван Медведев on 06.10.2020.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
	var window: UIWindow?

	func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.windowScene = windowScene
		let factory = Factory()
		window?.rootViewController = factory.createNavigationController()
		window?.makeKeyAndVisible()
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
