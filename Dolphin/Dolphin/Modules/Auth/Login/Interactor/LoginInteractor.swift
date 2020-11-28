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
			case .success(let authResult):
				self.keychainSwift.set(authResult.token.token, forKey: "token")
				self.keychainSwift.set("\(authResult.user.id)", forKey: "userId")
				self.keychainSwift.set(authResult.user.username, forKey: "username")
				self.keychainSwift.set(authResult.user.email, forKey: "email")
				self.keychainSwift.set(user.password, forKey: "password")
				if let encodedImage = authResult.user.encodedImage {
					self.keychainSwift.set(encodedImage, forKey: "encodedImage")
				}
				completion(.success(authResult))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
