//
//  ChatListPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

final class ChatListPresenter
{
// MARK: - Properties
	private weak var viewController: IChatListViewController?
	private let interactor: IChatListInteractor
	private let router: IChatListRouter

// MARK: - Init
	init(router: IChatListRouter, interactor: IChatListInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: IChatListViewController) {
		self.viewController = viewController
	}
}

// MARK: - IChatListPresenter
extension ChatListPresenter: IChatListPresenter
{
	func selectChatRoom(closure: (UIViewController) -> Void) {
		self.router.selectChatRoom { viewController in
			closure(viewController)
		}
	}
}
