//
//  DolphinAPISettings.swift
//  Dolphin
//
//  Created by Иван Медведев on 15.11.2020.
//

typealias LogoutResult = Result<String, Error>
typealias UpdateResult = Result<NewProfileData, Error>

import Foundation

enum DolphinAPIConstantsSettings
{
	static let baseURL = "https://dolphin-chat-backend.herokuapp.com/"
	static let logoutURL = "logout"
	static let updateURL = "user/update"
}

final class DolphinAPISettings
{
	private var task: URLSessionDataTask?

	func logout(token: String, completion: @escaping (LogoutResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstantsSettings.baseURL +
												DolphinAPIConstantsSettings.logoutURL) else {
			completion(.failure(SettingsNetworkErrors.wrongURL))
			return
		}
		guard let url = components.url else {
			completion(.failure(SettingsNetworkErrors.wrongURL))
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
		task = URLSession.shared.dataTask(with: request) { _, response, error in
			if error != nil {
				completion(.failure(SettingsNetworkErrors.dataTaskError))
			}
			if let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 200:
					completion(.success("Success"))
				default:
					print(response.statusCode)
					completion(.failure(SettingsNetworkErrors.badResponse))
				}
			}
		}
		task?.resume()
	}

	func update(newProfileData: NewProfileData, token: String, completion: @escaping (UpdateResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstantsSettings.baseURL +
												DolphinAPIConstantsSettings.updateURL) else {
			completion(.failure(SettingsNetworkErrors.wrongURL))
			return
		}
		guard let url = components.url else {
			completion(.failure(SettingsNetworkErrors.wrongURL))
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
		do {
			let newProfileData = try JSONEncoder().encode(newProfileData)
			request.httpBody = newProfileData
		}
		catch {
			completion(.failure(SettingsNetworkErrors.badProfileData))
		}
		task = URLSession.shared.dataTask(with: request) { _, response, error in
			if error != nil {
				completion(.failure(SettingsNetworkErrors.dataTaskError))
			}
			if let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 200:
					completion(.success(newProfileData))
				default:
					print(response.statusCode)
					completion(.failure(SettingsNetworkErrors.badResponse))
				}
			}
		}
		task?.resume()
	}
}
