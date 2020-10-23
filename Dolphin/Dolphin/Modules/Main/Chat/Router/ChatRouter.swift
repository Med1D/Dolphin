//
//  ChatRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

final class ChatRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - IChatRouter
extension ChatRouter: IChatRouter
{
}
