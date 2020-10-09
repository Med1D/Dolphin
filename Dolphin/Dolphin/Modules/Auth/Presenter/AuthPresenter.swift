//
//  AuthPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

final class AuthPresenter
{
	private weak var viewController: IAuthViewController?
	private let interactor: IAuthInteractor
	private let router: IAuthRouter

	init(router: IAuthRouter, interactor: IAuthInteractor) {
		self.router = router
		self.interactor = interactor
	}

	func inject(viewController: IAuthViewController) {
		self.viewController = viewController
	}
}

// MARK: - IAuthPresenter
extension AuthPresenter: IAuthPresenter
{
}
