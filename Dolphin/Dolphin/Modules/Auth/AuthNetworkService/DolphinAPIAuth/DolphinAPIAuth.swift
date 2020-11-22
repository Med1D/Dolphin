//
//  DolphinAPIAuth.swift
//  Dolphin
//
//  Created by Иван Медведев on 14.10.2020.
//

typealias RegisterResult = Result<String, Error>
typealias AuthResult = Result<AuthResponse, Error>

import Foundation

enum DolphinAPIConstantsAuth
{
	static let baseURL = "https://dolphin-chat-backend.herokuapp.com/"
	static let registerURL = "register"
	static let authURL = "auth"
}

final class DolphinAPIAuth
{
	private var task: URLSessionDataTask?

	func register(user: User, completion: @escaping (RegisterResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstantsAuth.baseURL +
												DolphinAPIConstantsAuth.registerURL) else {
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

	func auth(user: User, completion: @escaping (AuthResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstantsAuth.baseURL +
												DolphinAPIConstantsAuth.authURL) else {
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
		task = URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				completion(.failure(AuthNetworkErrors.dataTaskError))
			}
			guard let data = data else {
				completion(.failure(AuthNetworkErrors.dataTaskError))
				return
			}
			if let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 200:
					do {
						let dataJSON = try JSONDecoder().decode(AuthResponse.self, from: data)
						completion(.success(dataJSON))
					}
					catch {
						completion(.failure(AuthNetworkErrors.dataTaskError))
					}
				default:
					completion(.failure(AuthNetworkErrors.badResponse))
				}
			}
		}
		task?.resume()
	}
}
