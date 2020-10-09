//
//  AuthInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import Foundation

final class AuthInteractor
{
	private weak var presenter: IAuthPresenter?

	init() {
	}

	func inject(presenter: IAuthPresenter) {
		self.presenter = presenter
	}
}

// MARK: - IAuthInteractor
extension AuthInteractor: IAuthInteractor
{
}
