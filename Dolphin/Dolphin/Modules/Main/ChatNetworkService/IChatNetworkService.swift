//
//  IChatNetworkService.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import Foundation

protocol IChatNetworkService
{
	func getChatRooms(token: String, completion: @escaping (ChatRoomsResult) -> Void)
	func getChatMembers(token: String, roomId: Int, completion: @escaping (ChatMembersResult) -> Void)
	func updateChatRoomImage(newImage: NewImage, roomId: Int, completion: @escaping (ChatRoomImageResult) -> Void)
	func updateChatRoomTitle(newTitle title: String, roomId: Int, completion: @escaping (ChatRoomTitleResult) -> Void)
	func leaveChatRoom(token: String, roomId: Int, completion: @escaping (LeaveResult) -> Void)
	func getChatRoomMembersCount(roomId: Int, completion: @escaping (ChatRoomMembersCountResult) -> Void)
	func getMessages(roomId: Int, page: Int, completion: @escaping (ChatRoomMessagesResult) -> Void)
	func getChatMember(withId id: Int, completion: @escaping (ChatMemberResult) -> Void)
}
