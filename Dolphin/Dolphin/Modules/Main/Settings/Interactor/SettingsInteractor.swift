//
//  SettingsInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 23.10.2020.
//

import Foundation

final class SettingsInteractor
{
// MARK: - Properties
	private weak var presenter: ISettingsPresenter?
	private let settingsNetworkService: ISettingsNetworkService

// MARK: - Init
	init(settingsNetworkService: ISettingsNetworkService) {
		self.settingsNetworkService = settingsNetworkService
	}

// MARK: - Inject
	func inject(presenter: ISettingsPresenter) {
		self.presenter = presenter
	}
}

// MARK: - ISettingsInteractor
extension SettingsInteractor: ISettingsInteractor
{
}
