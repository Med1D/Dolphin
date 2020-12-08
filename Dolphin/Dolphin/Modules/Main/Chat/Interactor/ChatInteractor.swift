//
//  ChatInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import Foundation
import KeychainSwift

final class ChatInteractor
{
// MARK: - Properties
	private weak var presenter: IChatPresenter?
	private let chatNetworkService: IChatNetworkService
	private let keychainSwift = KeychainSwift()

// MARK: - Init
	init(chatNetworkService: IChatNetworkService) {
		self.chatNetworkService = chatNetworkService
	}

// MARK: - Inject
	func inject(presenter: IChatPresenter) {
		self.presenter = presenter
	}
}

// MARK: - IChatInteractor
extension ChatInteractor: IChatInteractor
{
	func getCurrentUserData() -> (userId: Int, username: String)? {
		guard let userIdString = self.keychainSwift.get("userId"),
			  let userId = Int(userIdString),
			  let username = self.keychainSwift.get("username") else {
			return nil
		}
		return (userId, username)
	}

	func getCurrentUserImage() -> UIImage? {
		guard let encodedImage = self.keychainSwift.get("encodedImage"),
			  let image = UIImage.decodeImageFromBase64String(string: encodedImage) else {
			return MainConstants.profileDefaultImage
		}
		return image
	}

	func getChatRoomMembersCount(roomId: Int, completion: @escaping (ChatRoomMembersCountResult) -> Void) {
		self.chatNetworkService.getChatRoomMembersCount(roomId: roomId) { result in
			switch result {
			case .success(let chatRoomMembersCount):
				completion(.success(chatRoomMembersCount))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getMessages(roomId: Int, page: Int, completion: @escaping (ChatRoomMessagesResult) -> Void) {
		self.chatNetworkService.getMessages(roomId: roomId, page: page) { result in
			switch result {
			case .success(let dolphinMessages):
				completion(.success(dolphinMessages))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getChatMember(withId id: Int, completion: @escaping (ChatMemberResult) -> Void) {
		self.chatNetworkService.getChatMember(withId: id) { result in
			switch result {
			case .success(let chatMember):
				completion(.success(chatMember))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
