//
//  IEditProfilePresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 25.11.2020.
//

import UIKit

protocol IEditProfilePresenter: AnyObject
{
	func getProfileImage(closure: (String?) -> Void)
	func getProfileName(closure: (String?) -> Void)
	func getProfileEmail(closure: (String?) -> Void)
	func getProfilePassword(closure: (String?) -> Void)
	func update(newProfileData: NewProfileData, completion: @escaping (UpdateResult) -> Void)
}
