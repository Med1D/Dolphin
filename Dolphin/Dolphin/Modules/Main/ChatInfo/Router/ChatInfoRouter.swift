//
//  ChatInfoRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 30.11.2020.
//

import UIKit

final class ChatInfoRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - IChatInfoRouter
extension ChatInfoRouter: IChatInfoRouter
{
}
