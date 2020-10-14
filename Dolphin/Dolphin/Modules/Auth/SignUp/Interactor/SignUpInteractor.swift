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
	private let authNetworkService: IAuthNetworkService

// MARK: - Init
	init(authNetworkService: IAuthNetworkService) {
		self.authNetworkService = authNetworkService
	}

// MARK: - Inject
	func inject(presenter: ISignUpPresenter) {
		self.presenter = presenter
	}
}

// MARK: - ISignUpInteractor
extension SignUpInteractor: ISignUpInteractor
{
	func touchSignUpButton(user: User, completion: @escaping (RegisterResult) -> Void) {
		self.authNetworkService.register(user: user) { result in
			switch result {
			case .success(let string):
				completion(.success(string))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
