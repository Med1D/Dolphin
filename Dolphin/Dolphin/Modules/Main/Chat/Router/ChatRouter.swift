//
//  ChatRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

final class ChatRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - IChatRouter
extension ChatRouter: IChatRouter
{
	func openChatInfo(chatRoomData: ChatRoomData, chatDelegate: ChatDelegate, closure: (UIViewController) -> Void) {
		let viewController = self.factory.createChatInfoModule(chatRoomData: chatRoomData, chatDelegate: chatDelegate)
		closure(viewController)
	}
}
