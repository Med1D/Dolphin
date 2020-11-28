//
//  EditProfileInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 25.11.2020.
//

import Foundation
import KeychainSwift

final class EditProfileInteractor
{
// MARK: - Properties
	private weak var presenter: IEditProfilePresenter?
	private let settingsNetworkService: ISettingsNetworkService
	private let keychainSwift = KeychainSwift()

// MARK: - Init
	init(settingsNetworkService: ISettingsNetworkService) {
		self.settingsNetworkService = settingsNetworkService
	}

// MARK: - Inject
	func inject(presenter: IEditProfilePresenter) {
		self.presenter = presenter
	}
}

// MARK: - IEditProfileInteractor
extension EditProfileInteractor: IEditProfileInteractor
{
	func getProfileImage(closure: (String?) -> Void) {
		let encodedImage = self.keychainSwift.get("encodedImage")
		closure(encodedImage)
	}

	func getProfileName(closure: (String?) -> Void) {
		let name = self.keychainSwift.get("username")
		closure(name)
	}

	func getProfileEmail(closure: (String?) -> Void) {
		let email = self.keychainSwift.get("email")
		closure(email)
	}

	func getProfilePassword(closure: (String?) -> Void) {
		let password = self.keychainSwift.get("password")
		closure(password)
	}

	func update(newProfileData: NewProfileData, completion: @escaping (UpdateResult) -> Void) {
		guard let token = self.keychainSwift.get("token") else { return }
		self.settingsNetworkService.update(newProfileData: newProfileData, token: token) { result in
			switch result {
			case .success(let data):
				self.keychainSwift.set(data.username, forKey: "username")
				self.keychainSwift.set(data.email, forKey: "email")
				self.keychainSwift.set(data.password, forKey: "password")
				if data.image.isDefaultImage == false, let encodedImage = data.image.encodedImage {
					self.keychainSwift.set(encodedImage, forKey: "encodedImage")
				}
				else {
					self.keychainSwift.delete("encodedImage")
				}
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
