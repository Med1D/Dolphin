//
//  DolphinAPIChat.swift
//  Dolphin
//
//  Created by Иван Медведев on 22.11.2020.
//

typealias ChatRoomsResult = Result<[ChatRoom], Error>
typealias ChatMembersResult = Result<[ChatMember], Error>
typealias ChatRoomImageResult = Result<NewImage, Error>
typealias ChatRoomTitleResult = Result<String, Error>
typealias LeaveResult = Result<String, Error>

import Foundation

enum DolphinAPIConstantsChat
{
	static let baseURL = "https://dolphin-chat-backend.herokuapp.com/"
	static let roomsList = "rooms/list"
	static let users = "rooms/list/users/"
	static let roomImage = "rooms/image/"
	static let roomTitle = "rooms/title/"
	static let roomLeave = "rooms/leave/"
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

	func getChatMembers(token: String, roomId: Int, completion: @escaping (ChatMembersResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstantsChat.baseURL +
												DolphinAPIConstantsChat.users + "\(roomId)") else {
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
						let chatMembers = try JSONDecoder().decode([ChatMember].self, from: data)
						completion(.success(chatMembers))
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

	func updateChatRoomImage(newImage: NewImage, roomId: Int, completion: @escaping (ChatRoomImageResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstantsChat.baseURL +
												DolphinAPIConstantsChat.roomImage + "\(roomId)") else {
			completion(.failure(ChatNetworkErrors.wrongURL))
			return
		}
		guard let url = components.url else {
			completion(.failure(ChatNetworkErrors.wrongURL))
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		do {
			let newImageData = try JSONEncoder().encode(newImage)
			request.httpBody = newImageData
		}
		catch {
			completion(.failure(ChatNetworkErrors.badData))
		}
		task = URLSession.shared.dataTask(with: request) { _, response, error in
			if error != nil {
				completion(.failure(ChatNetworkErrors.dataTaskError))
			}
			if let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 200:
					completion(.success(newImage))
				default:
					print(response.statusCode)
					completion(.failure(ChatNetworkErrors.badResponse))
				}
			}
		}
		task?.resume()
	}

	func updateChatRoomTitle(newTitle title: String, roomId: Int, completion: @escaping (ChatRoomTitleResult) -> Void) {
		guard var components = URLComponents(string: DolphinAPIConstantsChat.baseURL +
												DolphinAPIConstantsChat.roomTitle + "\(roomId)") else {
			completion(.failure(ChatNetworkErrors.wrongURL))
			return
		}
		let queryItemTitle = URLQueryItem(name: "title", value: title)
		components.queryItems = [queryItemTitle]
		guard let url = components.url else {
			completion(.failure(ChatNetworkErrors.wrongURL))
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		task = URLSession.shared.dataTask(with: request) { _, response, error in
			if error != nil {
				completion(.failure(ChatNetworkErrors.dataTaskError))
			}
			if let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 200:
					completion(.success(title))
				default:
					print(response.statusCode)
					completion(.failure(ChatNetworkErrors.badResponse))
				}
			}
		}
		task?.resume()
	}

	func leaveChatRoom(token: String, roomId: Int, completion: @escaping (LeaveResult) -> Void) {
		guard let components = URLComponents(string: DolphinAPIConstantsChat.baseURL +
												DolphinAPIConstantsChat.roomLeave + "\(roomId)") else {
			completion(.failure(ChatNetworkErrors.wrongURL))
			return
		}
		guard let url = components.url else {
			completion(.failure(ChatNetworkErrors.wrongURL))
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
		task = URLSession.shared.dataTask(with: request) { _, response, error in
			if error != nil {
				completion(.failure(ChatNetworkErrors.dataTaskError))
			}
			if let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 200:
					completion(.success("success"))
				default:
					print(response.statusCode)
					completion(.failure(ChatNetworkErrors.badResponse))
				}
			}
		}
		task?.resume()
	}
}
