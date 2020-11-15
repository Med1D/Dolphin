//
//  SettingsRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

final class SettingsRouter
{
// MARK: - Properties
	private let factory: Factory

// MARK: - Init
	init(factory: Factory) {
		self.factory = factory
	}
}

// MARK: - ISettingsRouter
extension SettingsRouter: ISettingsRouter
{
	func touchLogoutButton() {
		self.factory.createAuthNavigationController()
	}
}
