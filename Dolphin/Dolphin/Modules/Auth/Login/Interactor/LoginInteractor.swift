//
//  LoginInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import Foundation
import KeychainSwift

final class LoginInteractor
{
// MARK: - Properties
	private weak var presenter: ILoginPresenter?
	private let authNetworkService: IAuthNetworkService
	private let keychainSwift = KeychainSwift()

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
			case .success((let token, let userId)):
				self.keychainSwift.set(token, forKey: "token")
				self.keychainSwift.set("\(userId)", forKey: "userId")
				completion(.success((token, userId)))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
