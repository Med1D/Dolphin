//
//  ForgotPasswordPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 12.10.2020.
//

import UIKit

final class ForgotPasswordPresenter
{
// MARK: - Properties
	private weak var viewController: IForgotPasswordViewController?
	private let interactor: IForgotPasswordInteractor
	private let router: IForgotPasswordRouter

// MARK: - Init
	init(router: IForgotPasswordRouter, interactor: IForgotPasswordInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: IForgotPasswordViewController) {
		self.viewController = viewController
	}
}

// MARK: - IForgotPasswordPresenter
extension ForgotPasswordPresenter: IForgotPasswordPresenter
{
	func touchSendToEmailButton() {
		print(#function)
	}
}
