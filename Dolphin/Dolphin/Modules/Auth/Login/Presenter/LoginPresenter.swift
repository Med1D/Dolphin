//
//  LoginPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

final class LoginPresenter
{
// MARK: - Properties
	private weak var viewController: ILoginViewController?
	private let interactor: ILoginInteractor
	private let router: ILoginRouter

// MARK: - Init
	init(router: ILoginRouter, interactor: ILoginInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: ILoginViewController) {
		self.viewController = viewController
	}
}

// MARK: - ILoginPresenter
extension LoginPresenter: ILoginPresenter
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
