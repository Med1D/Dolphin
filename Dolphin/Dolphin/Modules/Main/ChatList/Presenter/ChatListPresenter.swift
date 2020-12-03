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
		self.router.selectChatRoom(chatRoomData: chatRoomData, chatListDelegate: self) { viewController in
			closure(viewController)
		}
	}
}

// MARK: - ChatListDelegate
extension ChatListPresenter: ChatListDelegate
{
	func refreshChatRoomInfo(chatRoomData: ChatRoomData) {
		for (index, chatRoom) in self.chatRooms.enumerated() where chatRoom.chatRoomData.id == chatRoomData.id {
			let newChatRoom = ChatRoom(chatRoomData: chatRoomData, lastMessage: self.chatRooms[index].lastMessage)
			self.chatRooms[index] = newChatRoom
			break
		}
		self.viewController?.reloadChatRoomsList()
	}

	func leaveChatRoom(id: Int) {
		for (index, chatRoom) in self.chatRooms.enumerated() where chatRoom.chatRoomData.id == id {
			self.chatRooms.remove(at: index)
			break
		}
		self.viewController?.reloadChatRoomsList()
	}
}
