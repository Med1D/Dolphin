//
//  IChatListPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

protocol IChatListPresenter: AnyObject
{
	func getChatRooms()
	func getChatRoom(at index: Int) -> ChatRoom
	func getChatRoomsCount() -> Int
	func selectChatRoom(chatRoomData: ChatRoomData, closure: (UIViewController) -> Void)
}
