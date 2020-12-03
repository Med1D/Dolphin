//
//  IChatListRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

protocol IChatListRouter: AnyObject
{
	func selectChatRoom(chatRoomData: ChatRoomData,
						chatListDelegate: ChatListDelegate,
						closure: (UIViewController) -> Void)
}
