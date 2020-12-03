//
//  IChatInfoInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 30.11.2020.
//

import Foundation

protocol IChatInfoInteractor: AnyObject
{
	func getChatMembers(roomId: Int, completion: @escaping (ChatMembersResult) -> Void)
	func updateChatRoomImage(newImage: NewImage, roomId: Int, completion: @escaping (ChatRoomImageResult) -> Void)
	func updateChatRoomTitle(newTitle title: String, roomId: Int, completion: @escaping (ChatRoomTitleResult) -> Void)
	func leaveChatRoom(roomId: Int, completion: @escaping (LeaveResult) -> Void)
}
