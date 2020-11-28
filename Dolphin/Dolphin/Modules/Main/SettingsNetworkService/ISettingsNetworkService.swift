//
//  ISettingsNetworkService.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import Foundation

protocol ISettingsNetworkService
{
	func logout(token: String, completion: @escaping (LogoutResult) -> Void)
	func update(newProfileData: NewProfileData, token: String, completion: @escaping (UpdateResult) -> Void)
}
