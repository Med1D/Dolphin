//
//  ChatListPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

final class ChatListPresenter
{
// MARK: - Properties
	private weak var viewController: IChatListViewController?
	private let interactor: IChatListInteractor
	private let router: IChatListRouter
	private var chatRooms: [ChatRoom] = []

// MARK: - Init
	init(router: IChatListRouter, interactor: IChatListInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: IChatListViewController) {
		self.viewController = viewController
	}
}

// MARK: - IChatListPresenter
extension ChatListPresenter: IChatListPresenter
{
	func getChatRooms() {
		self.interactor.getChatRooms { result in
			switch result {
			case .success(let chatRooms):
				self.chatRooms = chatRooms
				self.viewController?.reloadChatRoomsList()
			case .failure(let error):
				print(error)
			}
		}
	}

	func getChatRoom(at index: Int) -> ChatRoom {
		return self.chatRooms[index]
	}

	func getChatRoomsCount() -> Int {
		return self.chatRooms.count
	}

	func selectChatRoom(chatRoomData: ChatRoomData, closure: (UIViewController) -> Void) {
		self.router.selectChatRoom(chatRoomData: chatRoomData) { viewController in
			closure(viewController)
		}
	}
}
