//
//  Factory.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

final class Factory
{
	init() {
	}

	func createNavigationController() -> UINavigationController {
		let authModule = createAuthModule()
		let navigationController = UINavigationController(rootViewController: authModule)
		return navigationController
	}

	func createAuthModule() -> UIViewController {
		let router = AuthRouter(factory: self)
		let interactor = AuthInteractor()
		let presenter = AuthPresenter(router: router, interactor: interactor)
		let viewController = AuthViewController(presenter: presenter)
		presenter.inject(viewController: viewController)
		interactor.inject(presenter: presenter)
		return viewController
	}
}
