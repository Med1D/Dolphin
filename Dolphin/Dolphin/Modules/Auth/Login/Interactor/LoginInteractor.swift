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
	func auth(user: User, completion: @escaping (AuthResult) -> Void) {
		self.authNetworkService.auth(user: user) { result in
			switch result {
			case .success(let string):
				completion(.success(string))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
