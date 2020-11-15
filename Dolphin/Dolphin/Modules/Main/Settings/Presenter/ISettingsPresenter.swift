//
//  ISettingsPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

protocol ISettingsPresenter: AnyObject
{
	func touchLogoutButton(completion: @escaping (LogoutResult) -> Void)
}
