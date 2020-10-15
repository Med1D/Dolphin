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
	private let dolphinAPI = DolphinAPI()
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
			self.dolphinAPI.register(user: user) { result in
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
}