//
//  IChatInfoPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 30.11.2020.
//

import UIKit

protocol IChatInfoPresenter: AnyObject
{
	func setChatRoomData(title: String?, encodedImage: String?)
	func getChatRoomData() -> ChatRoomData
	func getChatMembers() -> [ChatMember]
	func getChatMember(at index: Int) -> ChatMember
	func getError() -> ChatNetworkErrors?
	func getChatMembersFromService()
	func updateChatRoomImage(newImage: NewImage, completion: @escaping (ChatRoomImageResult) -> Void)
	func updateChatRoomTitle(newTitle title: String, completion: @escaping (ChatRoomTitleResult) -> Void)
	func leaveChatRoom(completion: @escaping (LeaveResult) -> Void)
}
