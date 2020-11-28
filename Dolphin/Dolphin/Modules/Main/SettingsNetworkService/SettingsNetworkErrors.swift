//
//  SettingsNetworkErrors.swift
//  Dolphin
//
//  Created by Иван Медведев on 15.11.2020.
//

import Foundation

enum SettingsNetworkErrors: Error
{
	case wrongURL, badResponse, badProfileData, noConnection, dataTaskError
}
