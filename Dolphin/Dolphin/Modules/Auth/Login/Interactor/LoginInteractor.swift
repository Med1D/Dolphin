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
	private let authNetworkService: IAuthNetworkService

// MARK: - Init
	init(authNetworkService: IAuthNetworkService) {
		self.authNetworkService = authNetworkService
	}

// MARK: - Inject
	func inject(presenter: ILoginPresenter) {
		self.presenter = presenter
	}
}

// MARK: - ILoginInteractor
extension LoginInteractor: ILoginInteractor
{
}
