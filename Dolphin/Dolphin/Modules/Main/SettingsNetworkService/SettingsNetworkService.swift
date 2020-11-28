//
//  SettingsNetworkService.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import Foundation
import Network

final class SettingsNetworkService
{
	private let dolphinAPISettings = DolphinAPISettings()
	private let queue = DispatchQueue(label: "settingsNetworkMonitor")
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

// MARK: - ISettingsNetworkService
extension SettingsNetworkService: ISettingsNetworkService
{
	func logout(token: String, completion: @escaping (LogoutResult) -> Void) {
		if connection {
			self.dolphinAPISettings.logout(token: token) { result in
				switch result {
				case .success(let string):
					completion(.success(string))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
		else {
			completion(.failure(SettingsNetworkErrors.noConnection))
		}
	}

	func update(newProfileData: NewProfileData, token: String, completion: @escaping (UpdateResult) -> Void) {
		if connection {
			self.dolphinAPISettings.update(newProfileData: newProfileData, token: token) { result in
				switch result {
				case .success(let data):
					completion(.success(data))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
		else {
			completion(.failure(SettingsNetworkErrors.noConnection))
		}
	}
}
