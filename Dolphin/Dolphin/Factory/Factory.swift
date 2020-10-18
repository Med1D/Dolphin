//
//  Factory.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

final class Factory
{
	private let window: UIWindow

	init(window: UIWindow) {
		self.window = window
	}

	func createAuthNavigationController() {
		let loginModule = createLoginModule()
		let navigationController = UINavigationController(rootViewController: loginModule)
		self.changeRootViewController(viewController: navigationController)
	}

	func createChatTabBarController() {
		let chatListModule = self.createChatListModule()
		let navigationController = UINavigationController(rootViewController: chatListModule)
		let tabBarController = UITabBarController()
		tabBarController.viewControllers = [navigationController]
		self.changeRootViewController(viewController: tabBarController)
	}

	func changeRootViewController(viewController: UIViewController) {
		self.window.rootViewController = viewController
		UIView.transition(with: self.window,
						  duration: 0.25,
						  options: [.transitionCrossDissolve],
						  animations: nil,
						  completion: nil)
	}

	func createLoginModule() -> UIViewController {
		let authNetworkService: IAuthNetworkService = AuthNetworkService()
		let router = LoginRouter(factory: self)
		let interactor = LoginInteractor(authNetworkService: authNetworkService)
		let presenter = LoginPresenter(router: router, interactor: interactor)
		let viewController = LoginViewController(presenter: presenter)
		presenter.inject(viewController: viewController)
		interactor.inject(presenter: presenter)
		return viewController
	}

	func createSignUpModule() -> UIViewController {
		let authNetworkService: IAuthNetworkService = AuthNetworkService()
		let router = SignUpRouter(factory: self)
		let interactor = SignUpInteractor(authNetworkService: authNetworkService)
		let presenter = SignUpPresenter(router: router, interactor: interactor)
		let viewController = SignUpViewController(presenter: presenter)
		presenter.inject(viewController: viewController)
		interactor.inject(presenter: presenter)
		return viewController
	}

	func createForgotPasswordModule() -> UIViewController {
		let authNetworkService: IAuthNetworkService = AuthNetworkService()
		let router = ForgotPasswordRouter(factory: self)
		let interactor = ForgotPasswordInteractor(authNetworkService: authNetworkService)
		let presenter = ForgotPasswordPresenter(router: router, interactor: interactor)
		let viewController = ForgotPasswordViewController(presenter: presenter)
		presenter.inject(viewController: viewController)
		interactor.inject(presenter: presenter)
		return viewController
	}

	func createChatListModule() -> UIViewController {
		let chatNetworkService: IChatNetworkService = ChatNetworkService()
		let router = ChatListRouter(factory: self)
		let interactor = ChatListInteractor(chatNetworkService: chatNetworkService)
		let presenter = ChatListPresenter(router: router, interactor: interactor)
		let viewController = ChatListViewController(presenter: presenter)
		presenter.inject(viewController: viewController)
		interactor.inject(presenter: presenter)
		return viewController
	}
}
