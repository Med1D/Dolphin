//
//  AuthRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

final class AuthRouter
{
	private let factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - IAuthRouter
extension AuthRouter: IAuthRouter
{
}
