//
//  ForgotPasswordInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 12.10.2020.
//

import Foundation

final class ForgotPasswordInteractor
{
// MARK: - Properties
	private weak var presenter: IForgotPasswordPresenter?

// MARK: - Init
	init() {
	}

// MARK: - Inject
	func inject(presenter: IForgotPasswordPresenter) {
		self.presenter = presenter
	}
}

// MARK: - IForgotPasswordInteractor
extension ForgotPasswordInteractor: IForgotPasswordInteractor
{
}