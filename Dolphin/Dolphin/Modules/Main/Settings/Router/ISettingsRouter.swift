//
//  ISettingsRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

protocol ISettingsRouter: AnyObject
{
	func touchEditProfileButton(closure: (UIViewController) -> Void)
	func touchLogoutButton()
}
