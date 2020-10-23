//
//  SettingsPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

final class SettingsPresenter
{
// MARK: - Properties
	private weak var viewController: ISettingsViewController?
	private let interactor: ISettingsInteractor
	private let router: ISettingsRouter

// MARK: - Init
	init(router: ISettingsRouter, interactor: ISettingsInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: ISettingsViewController) {
		self.viewController = viewController
	}
}

// MARK: - ISettingsPresenter
extension SettingsPresenter: ISettingsPresenter
{
}
