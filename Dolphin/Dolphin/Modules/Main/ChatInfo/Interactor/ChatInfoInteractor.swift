//
//  ChatInfoInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 30.11.2020.
//

import Foundation
import KeychainSwift

final class ChatInfoInteractor
{
// MARK: - Properties
	private weak var presenter: IChatInfoPresenter?
	private let chatNetworkService: IChatNetworkService
	private let keychainSwift = KeychainSwift()

// MARK: - Init
	init(chatNetworkService: IChatNetworkService) {
		self.chatNetworkService = chatNetworkService
	}

// MARK: - Inject
	func inject(presenter: IChatInfoPresenter) {
		self.presenter = presenter
	}
}

// MARK: - IChatInfoInteractor
extension ChatInfoInteractor: IChatInfoInteractor
{
	func getChatMembers(roomId: Int, completion: @escaping (ChatMembersResult) -> Void) {
		guard let token = self.keychainSwift.get("token") else { return }
		self.chatNetworkService.getChatMembers(token: token, roomId: roomId) { result in
			switch result {
			case .success(let chatMembers):
				completion(.success(chatMembers))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func updateChatRoomImage(newImage: NewImage, roomId: Int, completion: @escaping (ChatRoomImageResult) -> Void) {
		self.chatNetworkService.updateChatRoomImage(newImage: newImage, roomId: roomId) { result in
			switch result {
			case .success(let newImage):
				completion(.success(newImage))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func updateChatRoomTitle(newTitle title: String, roomId: Int, completion: @escaping (ChatRoomTitleResult) -> Void) {
		self.chatNetworkService.updateChatRoomTitle(newTitle: title, roomId: roomId) { result in
			switch result {
			case .success(let newTitle):
				completion(.success(newTitle))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func leaveChatRoom(roomId: Int, completion: @escaping (LeaveResult) -> Void) {
		guard let token = self.keychainSwift.get("token") else { return }
		self.chatNetworkService.leaveChatRoom(token: token, roomId: roomId) { result in
			switch result {
			case .success(let string):
				completion(.success(string))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
