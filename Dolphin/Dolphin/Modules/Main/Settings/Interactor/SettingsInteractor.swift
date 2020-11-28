//
//  SettingsInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 23.10.2020.
//

import Foundation
import KeychainSwift

final class SettingsInteractor
{
// MARK: - Properties
	private weak var presenter: ISettingsPresenter?
	private let settingsNetworkService: ISettingsNetworkService
	private let keychainSwift = KeychainSwift()

// MARK: - Init
	init(settingsNetworkService: ISettingsNetworkService) {
		self.settingsNetworkService = settingsNetworkService
	}

// MARK: - Inject
	func inject(presenter: ISettingsPresenter) {
		self.presenter = presenter
	}
}

// MARK: - ISettingsInteractor
extension SettingsInteractor: ISettingsInteractor
{
	func touchLogoutButton(completion: @escaping (LogoutResult) -> Void) {
		guard let token = self.keychainSwift.get("token") else { return }
		self.settingsNetworkService.logout(token: token) { result in
			switch result {
			case .success(let string):
				self.keychainSwift.delete("token")
				self.keychainSwift.delete("userId")
				self.keychainSwift.delete("username")
				self.keychainSwift.delete("email")
				self.keychainSwift.delete("password")
				self.keychainSwift.delete("encodedImage")
				completion(.success(string))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
