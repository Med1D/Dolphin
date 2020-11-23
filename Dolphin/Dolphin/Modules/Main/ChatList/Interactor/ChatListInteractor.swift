//
//  ChatListInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import Foundation
import KeychainSwift

final class ChatListInteractor
{
// MARK: - Properties
	private weak var presenter: IChatListPresenter?
	private let chatNetworkService: IChatNetworkService
	private let keychainSwift = KeychainSwift()

// MARK: - Init
	init(chatNetworkService: IChatNetworkService) {
		self.chatNetworkService = chatNetworkService
	}

// MARK: - Inject
	func inject(presenter: IChatListPresenter) {
		self.presenter = presenter
	}
}

// MARK: - IChatListInteractor
extension ChatListInteractor: IChatListInteractor
{
	func getChatRooms(completion: @escaping (ChatRoomsResult) -> Void) {
		guard let token = self.keychainSwift.get("token") else { return }
		self.chatNetworkService.getChatRooms(token: token) { result in
			switch result {
			case .success(let chatRooms):
				completion(.success(chatRooms))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
