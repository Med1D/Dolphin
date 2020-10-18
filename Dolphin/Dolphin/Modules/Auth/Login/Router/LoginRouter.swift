//
//  LoginRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

final class LoginRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - ILoginRouter
extension LoginRouter: ILoginRouter
{
	func touchLoginButton() {
		self.factory.createChatTabBarController()
	}

	func touchForgotPasswordButton(closure: (UIViewController) -> Void) {
		let forgotPasswordModule = self.factory.createForgotPasswordModule()
		closure(forgotPasswordModule)
	}

	func touchSignUpButton(closure: (UIViewController) -> Void) {
		let signUpModule = self.factory.createSignUpModule()
		closure(signUpModule)
	}
}
