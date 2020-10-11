//
//  SignUpInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 11.10.2020.
//

import Foundation

final class SignUpInteractor
{
// MARK: - Properties
	private weak var presenter: ISignUpPresenter?

// MARK: - Init
	init() {
	}

// MARK: - Inject
	func inject(presenter: ISignUpPresenter) {
		self.presenter = presenter
	}
}

// MARK: - ISignUpInteractor
extension SignUpInteractor: ISignUpInteractor
{
}
