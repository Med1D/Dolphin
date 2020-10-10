//
//  AuthPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

final class AuthPresenter
{
// MARK: - Properties
	private weak var viewController: IAuthViewController?
	private let interactor: IAuthInteractor
	private let router: IAuthRouter

// MARK: - Init
	init(router: IAuthRouter, interactor: IAuthInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: IAuthViewController) {
		self.viewController = viewController
	}
}

// MARK: - IAuthPresenter
extension AuthPresenter: IAuthPresenter
{
	func touchLoginButton() {
		print(#function)
	}

	func touchForgotPasswordButton() {
		print(#function)
	}

	func touchSignUpButton() {
		print(#function)
	}
}
