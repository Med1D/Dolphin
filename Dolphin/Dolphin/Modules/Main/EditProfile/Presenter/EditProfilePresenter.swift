//
//  EditProfilePresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 25.11.2020.
//

import UIKit

final class EditProfilePresenter
{
// MARK: - Properties
	private weak var viewController: IEditProfileViewController?
	private let interactor: IEditProfileInteractor
	private let router: IEditProfileRouter

// MARK: - Init
	init(router: IEditProfileRouter, interactor: IEditProfileInteractor) {
		self.router = router
		self.interactor = interactor
	}

// MARK: - Inject
	func inject(viewController: IEditProfileViewController) {
		self.viewController = viewController
	}
}

// MARK: - IEditProfilePresenter
extension EditProfilePresenter: IEditProfilePresenter
{
	func getProfileImage(closure: (String?) -> Void) {
		self.interactor.getProfileImage { string in
			closure(string)
		}
	}

	func getProfileName(closure: (String?) -> Void) {
		self.interactor.getProfileName { string in
			closure(string)
		}
	}

	func getProfileEmail(closure: (String?) -> Void) {
		self.interactor.getProfileEmail { string in
			closure(string)
		}
	}

	func getProfilePassword(closure: (String?) -> Void) {
		self.interactor.getProfilePassword { string in
			closure(string)
		}
	}

	func update(newProfileData: NewProfileData, completion: @escaping (UpdateResult) -> Void) {
		self.interactor.update(newProfileData: newProfileData) { result in
			switch result {
			case .success(let data):
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
