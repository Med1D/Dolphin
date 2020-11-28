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
	func touchEditProfileButton(closure: (UIViewController) -> Void) {
		self.router.touchEditProfileButton { viewController in
			closure(viewController)
		}
	}

	func touchLogoutButton(completion: @escaping (LogoutResult) -> Void) {
		self.interactor.touchLogoutButton { result in
			switch result {
			case .success(let string):
				completion(.success(string))
				DispatchQueue.main.async {
					self.router.touchLogoutButton()
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
