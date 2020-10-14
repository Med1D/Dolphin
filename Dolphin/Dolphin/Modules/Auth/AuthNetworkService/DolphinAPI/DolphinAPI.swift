//
//  DolphinAPI.swift
//  Dolphin
//
//  Created by Иван Медведев on 14.10.2020.
//

typealias RegisterResult = Result<String, Error>

import Foundation

enum DolphinAPIConstants
{
	static let baseURL = "https://dolphin-chat-backend.herokuapp.com/"
	static let registerURL = "register"
	static let authURL = "auth"
}

final class DolphinAPI
{
	private var task: URLSessionDataTask?

	func register(user: User, completion: @escaping (RegisterResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstants.baseURL + DolphinAPIConstants.registerURL) else {
			completion(.failure(AuthNetworkErrors.wrongURL))
			return
		}
		guard let url = components.url else {
			completion(.failure(AuthNetworkErrors.wrongURL))
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		do {
			let userData = try JSONEncoder().encode(user)
			request.httpBody = userData
		}
		catch {
			completion(.failure(AuthNetworkErrors.badUserData))
		}
		task = URLSession.shared.dataTask(with: request) { _, response, error in
			if error != nil {
				completion(.failure(AuthNetworkErrors.dataTaskError))
			}
			if let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 200:
					completion(.success("Success"))
				default:
					completion(.failure(AuthNetworkErrors.badResponse))
				}
			}
		}
		task?.resume()
	}
}
