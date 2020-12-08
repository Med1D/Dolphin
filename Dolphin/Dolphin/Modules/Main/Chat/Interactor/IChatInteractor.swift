//
//  IChatInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

protocol IChatInteractor: AnyObject
{
	func getCurrentUserData() -> (userId: Int, username: String)?
	func getCurrentUserImage() -> UIImage?
	func getChatRoomMembersCount(roomId: Int, completion: @escaping (ChatRoomMembersCountResult) -> Void)
	func getMessages(roomId: Int, page: Int, completion: @escaping (ChatRoomMessagesResult) -> Void)
	func getChatMember(withId id: Int, completion: @escaping (ChatMemberResult) -> Void)
}
