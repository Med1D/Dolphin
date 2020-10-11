//
//  SignUpPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 11.10.2020.
//

import UIKit

final class SignUpPresenter
{
// MARK: - Properties
	private weak var viewController: ISignUpViewController?
	private let interactor: ISignUpInteractor
	private let router: ISignUpRouter

// MARK: - Init
	init(router: ISignUpRouter, interactor: ISignUpInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: ISignUpViewController) {
		self.viewController = viewController
	}
}

// MARK: - ISignUpPresenter
extension SignUpPresenter: ISignUpPresenter
{
	func touchSignUpButton() {
		print(#function)
	}
}
