//
//  LoginInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import Foundation

final class LoginInteractor
{
// MARK: - Properties
	private weak var presenter: ILoginPresenter?

// MARK: - Init
	init() {
	}

// MARK: - Inject
	func inject(presenter: ILoginPresenter) {
		self.presenter = presenter
	}
}

// MARK: - IAuthInteractor
extension LoginInteractor: ILoginInteractor
{
}
