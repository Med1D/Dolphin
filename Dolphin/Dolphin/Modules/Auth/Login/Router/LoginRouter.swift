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
	func touchSignUpButton(closure: (UIViewController) -> Void) {
		let signUpModule = factory.createSignUpModule()
		closure(signUpModule)
	}
}
