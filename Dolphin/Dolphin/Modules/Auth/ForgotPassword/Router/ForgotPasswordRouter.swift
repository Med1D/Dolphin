//
//  ForgotPasswordRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 12.10.2020.
//

import UIKit

final class ForgotPasswordRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - IForgotPasswordRouter
extension ForgotPasswordRouter: IForgotPasswordRouter
{
}
