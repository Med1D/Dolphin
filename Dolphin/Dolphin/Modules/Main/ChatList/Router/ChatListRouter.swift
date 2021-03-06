//
//  ChatListRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

final class ChatListRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - IChatListRouter
extension ChatListRouter: IChatListRouter
{
	func selectChatRoom(chatRoomData: ChatRoomData,
						chatListDelegate: ChatListDelegate,
						closure: (UIViewController) -> Void) {
		let chatModule = self.factory.createChatModule(chatRoomData: chatRoomData, chatListDelegate: chatListDelegate)
		closure(chatModule)
	}
}
