//
//  ChatInfoPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 30.11.2020.
//

import UIKit

final class ChatInfoPresenter
{
// MARK: - Properties
	private weak var viewController: IChatInfoViewController?
	private let interactor: IChatInfoInteractor
	private let router: IChatInfoRouter
	private weak var chatDelegate: ChatDelegate?
	private var chatRoomData: ChatRoomData
	private var chatMembers: [ChatMember] = []
	private var error: Error?

// MARK: - Init
	init(router: IChatInfoRouter, interactor: IChatInfoInteractor, chatRoomData: ChatRoomData) {
		self.router = router
		self.interactor = interactor
		self.chatRoomData = chatRoomData
	}

// MARK: - Inject
	func inject(viewController: IChatInfoViewController) {
		self.viewController = viewController
	}

	func inject(chatDelegate: ChatDelegate) {
		self.chatDelegate = chatDelegate
	}
}

// MARK: - Private methods
private extension ChatInfoPresenter
{
	func refreshChatModuleData() {
		self.chatDelegate?.refreshChatRoomInfo(chatRoomData: self.chatRoomData)
	}
}

// MARK: - IChatInfoPresenter
extension ChatInfoPresenter: IChatInfoPresenter
{
	func setChatRoomData(title: String?, encodedImage: String?) {
		if let title = title {
			let chatRoomData = ChatRoomData(id: self.chatRoomData.id,
											title: title,
											encodedImage: self.chatRoomData.encodedImage)
			self.chatRoomData = chatRoomData
		}
		if let encodedImage = encodedImage {
			let chatRoomData = ChatRoomData(id: self.chatRoomData.id,
											title: self.chatRoomData.title,
											encodedImage: encodedImage)
			self.chatRoomData = chatRoomData
		}
		self.refreshChatModuleData()
	}

	func getChatRoomData() -> ChatRoomData {
		return self.chatRoomData
	}

	func getChatMembers() -> [ChatMember] {
		return self.chatMembers
	}

	func getChatMember(at index: Int) -> ChatMember {
		return self.chatMembers[index]
	}

	func getError() -> ChatNetworkErrors? {
		return self.error as? ChatNetworkErrors
	}

	func getChatMembersFromService() {
		let roomId = self.chatRoomData.id
		self.interactor.getChatMembers(roomId: roomId) { result in
			switch result {
			case .success(let chatMembers):
				self.chatMembers = chatMembers
				self.error = nil
			case .failure(let error):
				self.chatMembers = []
				self.error = error
			}
			self.viewController?.reloadChatMembers()
		}
	}

	func updateChatRoomImage(newImage: NewImage, completion: @escaping (ChatRoomImageResult) -> Void) {
		let roomId = self.chatRoomData.id
		self.interactor.updateChatRoomImage(newImage: newImage, roomId: roomId) { result in
			switch result {
			case .success(let newImage):
				completion(.success(newImage))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func updateChatRoomTitle(newTitle title: String, completion: @escaping (ChatRoomTitleResult) -> Void) {
		let roomId = self.chatRoomData.id
		self.interactor.updateChatRoomTitle(newTitle: title, roomId: roomId) { result in
			switch result {
			case .success(let newTitle):
				completion(.success(newTitle))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func leaveChatRoom(completion: @escaping (LeaveResult) -> Void) {
		let roomId = self.chatRoomData.id
		self.interactor.leaveChatRoom(roomId: roomId) { result in
			switch result {
			case .success(let string):
				self.chatDelegate?.leaveChatRoom(id: roomId)
				completion(.success(string))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
