//
//  ChatPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

final class ChatPresenter
{
// MARK: - Properties
	private weak var viewController: IChatViewController?
	private let interactor: IChatInteractor
	private let router: IChatRouter

// MARK: - Init
	init(router: IChatRouter, interactor: IChatInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: IChatViewController) {
		self.viewController = viewController
	}
}

// MARK: - IChatPresenter
extension ChatPresenter: IChatPresenter
{
}
