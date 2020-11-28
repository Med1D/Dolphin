//
//  EditProfileRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 25.11.2020.
//

import UIKit

final class EditProfileRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - IEditProfileRouter
extension EditProfileRouter: IEditProfileRouter
{
}
