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
		let loginModule = createLoginModule()
		let navigationController = UINavigationController(rootViewController: loginModule)
		return navigationController
	}

	func createLoginModule() -> UIViewController {
		let router = LoginRouter(factory: self)
		let interactor = LoginInteractor()
		let presenter = LoginPresenter(router: router, interactor: interactor)
		let viewController = LoginViewController(presenter: presenter)
		presenter.inject(viewController: viewController)
		interactor.inject(presenter: presenter)
		return viewController
	}
}
