//
//  ChatInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import Foundation

final class ChatInteractor
{
// MARK: - Properties
	private weak var presenter: IChatPresenter?
	private let chatNetworkService: IChatNetworkService

// MARK: - Init
	init(chatNetworkService: IChatNetworkService) {
		self.chatNetworkService = chatNetworkService
	}

// MARK: - Inject
	func inject(presenter: IChatPresenter) {
		self.presenter = presenter
	}
}

// MARK: - IChatInteractor
extension ChatInteractor: IChatInteractor
{
}
