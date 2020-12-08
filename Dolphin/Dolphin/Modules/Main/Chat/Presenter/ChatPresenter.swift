//
//  ChatPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit
import MessageKit

final class ChatPresenter
{
// MARK: - Properties
	private weak var viewController: IChatViewController?
	private let interactor: IChatInteractor
	private let router: IChatRouter
	private weak var chatListDelegate: ChatListDelegate?
	private var chatRoomData: ChatRoomData
	private var membersCount: Int?
	private var messages: [MessageType] = []
	private var chatMembers: [ChatMember] = []
	private var page = 1

// MARK: - Init
	init(router: IChatRouter, interactor: IChatInteractor, chatRoomData: ChatRoomData) {
		self.router = router
		self.interactor = interactor
		self.chatRoomData = chatRoomData
	}

// MARK: - Inject
	func inject(viewController: IChatViewController) {
		self.viewController = viewController
	}

	func inject(chatListDelegate: ChatListDelegate) {
		self.chatListDelegate = chatListDelegate
	}
}

// MARK: - IChatPresenter
extension ChatPresenter: IChatPresenter
{
	func getChatRoomData() -> ChatRoomData {
		return self.chatRoomData
	}

	func openChatInfo(closure: (UIViewController) -> Void) {
		self.router.openChatInfo(chatRoomData: self.chatRoomData, chatDelegate: self) { viewController in
			closure(viewController)
		}
	}

	func getCurrentUserData() -> (userId: Int, username: String)? {
		return self.interactor.getCurrentUserData()
	}

	func getCurrentUserImage() -> UIImage? {
		return self.interactor.getCurrentUserImage()
	}

	func getMessage(at index: Int) -> MessageType {
		return self.messages[index]
	}

	func getMessagesCount() -> Int {
		return self.messages.count
	}

	func getMembersCount() -> Int? {
		return self.membersCount
	}

	func getPage() -> Int {
		self.page += 1
		return self.page - 1
	}

	func sendMessage(message: MessageType) {
		self.messages.append(message)
		self.viewController?.insertMessage()
	}

	func getChatRoomMembersCount() {
		self.interactor.getChatRoomMembersCount(roomId: self.chatRoomData.id) { result in
			switch result {
			case .success(let chatRoomMembersCount):
				self.membersCount = chatRoomMembersCount.count
				self.viewController?.refreshChatRoomInfo()
			case .failure:
				self.membersCount = nil
				self.viewController?.refreshChatRoomInfo()
			}
		}
	}
//swiftlint:disable function_body_length
	func getMessages(page: Int) {
		self.interactor.getMessages(roomId: self.chatRoomData.id, page: page) { result in
			switch result {
			case .success(let dolphinMessages):
				var messages: [Message] = []
				var chatMembers: [ChatMember] = []
				let dispatchGroup = DispatchGroup()
				let dispatchQueue = DispatchQueue(label: "getMessages")
				dispatchQueue.async {
					dolphinMessages.forEach { dolphinMessage in
						dispatchGroup.enter()
						self.interactor.getChatMember(withId: dolphinMessage.senderId) { result in
							switch result {
							case .success(let chatMember):
								chatMembers.append(chatMember)
								dispatchGroup.leave()
							case .failure:
								dispatchGroup.leave()
							}
						}
						dispatchGroup.wait()
						var messageKind: MessageKind
						switch dolphinMessage.messageType {
						case "text":
							messageKind = .text(dolphinMessage.text)
						default:
							messageKind = .text(dolphinMessage.text)
						}
						let senders = chatMembers.filter { $0.id == dolphinMessage.senderId }
						if let sender = senders.first {
							let message = Message(sender: MessageSender(senderId: "\(dolphinMessage.senderId)",
																		displayName: sender.username),
												  messageId: "\(dolphinMessage.id)",
												  sentDate: Date(timeIntervalSince1970: TimeInterval(dolphinMessage.sendTimestamp)),
												  kind: messageKind)
							messages.append(message)
						}
					}
					if page == 1 {
						self.messages = messages
						self.chatMembers = chatMembers
						self.viewController?.loadFirstMessages()
					}
					else {
						self.messages.insert(contentsOf: messages, at: 0)
						self.chatMembers.insert(contentsOf: chatMembers, at: 0)
						self.viewController?.loadMoreMessages()
					}
				}
			case .failure:
				print("Loading is failed")
			}
		}
	}

	func getChatMemberImage(withSenderId id: Int) -> UIImage? {
		let chatMembers = self.chatMembers.filter { $0.id == id }
		if let member = chatMembers.first,
		   let encodedImage = member.encodedImage,
		   encodedImage.isEmpty == false,
		   let image = UIImage.decodeImageFromBase64String(string: encodedImage) {
			return image
		}
		else {
			return MainConstants.profileDefaultImage
		}
	}
}

// MARK: - ChatDelegate
extension ChatPresenter: ChatDelegate
{
	func refreshChatRoomInfo(chatRoomData: ChatRoomData) {
		self.chatRoomData = chatRoomData
		self.viewController?.refreshChatRoomInfo()
		self.chatListDelegate?.refreshChatRoomInfo(chatRoomData: self.chatRoomData)
	}

	func leaveChatRoom(id: Int) {
		self.chatListDelegate?.leaveChatRoom(id: id)
	}
}
