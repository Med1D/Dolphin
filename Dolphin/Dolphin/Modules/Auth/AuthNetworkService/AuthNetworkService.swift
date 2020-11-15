//
//  AuthNetworkService.swift
//  Dolphin
//
//  Created by Иван Медведев on 14.10.2020.
//

import Foundation
import Network

final class AuthNetworkService
{
	private let dolphinAPIAuth = DolphinAPIAuth()
	private let queue = DispatchQueue(label: "Monitor")
	private let monitor = NWPathMonitor()
	private var connection = false

	init() {
		self.monitor.pathUpdateHandler = { path in
			if path.status == .satisfied {
				self.connection = true
			}
			else {
				self.connection = false
			}
		}
		self.monitor.start(queue: self.queue)
	}
}

// MARK: - IAuthNetworkService
extension AuthNetworkService: IAuthNetworkService
{
	func register(user: User, completion: @escaping (RegisterResult) -> Void) {
		if connection {
			self.dolphinAPIAuth.register(user: user) { result in
				switch result {
				case .success(let string):
					completion(.success(string))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
		else {
			completion(.failure(AuthNetworkErrors.noConnection))
		}
	}

	func auth(user: User, completion: @escaping (AuthResult) -> Void) {
		if connection {
			self.dolphinAPIAuth.auth(user: user) { result in
				switch result {
				case .success((let token, let userId)):
					completion(.success((token, userId)))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
		else {
			completion(.failure(AuthNetworkErrors.noConnection))
		}
	}
}
