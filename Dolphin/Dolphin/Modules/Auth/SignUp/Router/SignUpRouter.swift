//
//  SignUpRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 11.10.2020.
//

import UIKit

final class SignUpRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - ISignUpRouter
extension SignUpRouter: ISignUpRouter
{
}
