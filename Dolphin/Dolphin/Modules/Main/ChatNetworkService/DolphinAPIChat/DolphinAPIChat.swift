//
//  DolphinAPIChat.swift
//  Dolphin
//
//  Created by Иван Медведев on 22.11.2020.
//

typealias ChatRoomsResult = Result<[ChatRoom], Error>

import Foundation

enum DolphinAPIConstantsChat
{
	static let baseURL = "https://dolphin-chat-backend.herokuapp.com/"
	static let roomsList = "rooms/list"
}

final class DolphinAPIChat
{
	private var task: URLSessionDataTask?

	func getChatRooms(token: String, completion: @escaping (ChatRoomsResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstantsChat.baseURL +
												DolphinAPIConstantsChat.roomsList) else {
			completion(.failure(ChatNetworkErrors.wrongURL))
			return
		}
		guard let url = components.url else {
			completion(.failure(ChatNetworkErrors.wrongURL))
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
		task = URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				completion(.failure(ChatNetworkErrors.dataTaskError))
			}
			if let response = response as? HTTPURLResponse, let data = data {
				switch response.statusCode {
				case 200:
					do {
						let chatRooms = try JSONDecoder().decode([ChatRoom].self, from: data)
						completion(.success(chatRooms))
					}
					catch {
						completion(.failure(ChatNetworkErrors.dataTaskError))
					}
				default:
					print(response.statusCode)
					completion(.failure(SettingsNetworkErrors.badResponse))
				}
			}
		}
		task?.resume()
	}
}
