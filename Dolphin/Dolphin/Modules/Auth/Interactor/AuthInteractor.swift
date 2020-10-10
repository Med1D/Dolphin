//
//  AuthInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import Foundation

final class AuthInteractor
{
// MARK: - Properties
	private weak var presenter: IAuthPresenter?

// MARK: - Init
	init() {
	}

// MARK: - Inject
	func inject(presenter: IAuthPresenter) {
		self.presenter = presenter
	}
}

// MARK: - IAuthInteractor
extension AuthInteractor: IAuthInteractor
{
}
