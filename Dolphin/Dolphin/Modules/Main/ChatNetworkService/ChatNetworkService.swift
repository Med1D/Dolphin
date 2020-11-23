//
//  ChatNetworkService.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import Foundation
import Network

final class ChatNetworkService
{
	private let dolphinAPIChat = DolphinAPIChat()
	private let queue = DispatchQueue(label: "chatNetworkMonitor")
	private let monitor = NWPathMonitor()
	private var connection = false
	private let timerQueue = DispatchQueue(label: "timerQueue", qos: .userInteractive)
	private let timer: DispatchSourceTimer

	init() {
		self.timer = DispatchSource.makeTimerSource(flags: [], queue: self.timerQueue)
		timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .seconds(1))
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

// MARK: - IChatNetworkService
extension ChatNetworkService: IChatNetworkService
{
	func getChatRooms(token: String, completion: @escaping (ChatRoomsResult) -> Void) {
		if connection {
			self.dolphinAPIChat.getChatRooms(token: token) { result in
				switch result {
				case .success(let chatRooms):
					completion(.success(chatRooms))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
		else {
			completion(.failure(ChatNetworkErrors.noConnection))
		}
	}
}
