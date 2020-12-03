//
//  ChatListDelegate.swift
//  Dolphin
//
//  Created by Иван Медведев on 03.12.2020.
//

import Foundation

protocol ChatListDelegate: AnyObject
{
	func refreshChatRoomInfo(chatRoomData: ChatRoomData)
	func leaveChatRoom(id: Int)
}
