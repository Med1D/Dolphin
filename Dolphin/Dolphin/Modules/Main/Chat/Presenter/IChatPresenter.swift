//
//  IChatPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit
import MessageKit

protocol IChatPresenter: AnyObject
{
	func getChatRoomData() -> ChatRoomData
	func openChatInfo(closure: (UIViewController) -> Void)
	func getCurrentUserData() -> (userId: Int, username: String)?
	func getCurrentUserImage() -> UIImage?
	func getMessage(at index: Int) -> MessageType
	func getMessagesCount() -> Int
	func getMembersCount() -> Int?
	func getPage() -> Int
	func sendMessage(message: MessageType)
	func getChatRoomMembersCount()
	func getMessages(page: Int)
	func getChatMemberImage(withSenderId id: Int) -> UIImage?
}
