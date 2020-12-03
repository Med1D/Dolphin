//
//  ChatPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

final class ChatPresenter
{
// MARK: - Properties
	private weak var viewController: IChatViewController?
	private let interactor: IChatInteractor
	private let router: IChatRouter
	private weak var chatListDelegate: ChatListDelegate?
	private var chatRoomData: ChatRoomData

// MARK: - Init
	init(router: IChatRouter, interactor: IChatInteractor, chatRoomData: ChatRoomData) {
		self.router = router
		self.interactor = interactor
		self.chatRoomData = chatRoomData
	}

// MARK: - Inject
	func inject(viewController: IChatViewController) {
		self.viewController = viewController
	}

	func inject(chatListDelegate: ChatListDelegate) {
		self.chatListDelegate = chatListDelegate
	}
}

// MARK: - IChatPresenter
extension ChatPresenter: IChatPresenter
{
	func getChatRoomData() -> ChatRoomData {
		return self.chatRoomData
	}

	func openChatInfo(closure: (UIViewController) -> Void) {
		self.router.openChatInfo(chatRoomData: self.chatRoomData, chatDelegate: self) { viewController in
			closure(viewController)
		}
	}
}

// MARK: - ChatDelegate
extension ChatPresenter: ChatDelegate
{
	func refreshChatRoomInfo(chatRoomData: ChatRoomData) {
		self.chatRoomData = chatRoomData
		self.viewController?.refreshChatRoomInfo()
		self.chatListDelegate?.refreshChatRoomInfo(chatRoomData: self.chatRoomData)
	}

	func leaveChatRoom(id: Int) {
		self.chatListDelegate?.leaveChatRoom(id: id)
	}
}
