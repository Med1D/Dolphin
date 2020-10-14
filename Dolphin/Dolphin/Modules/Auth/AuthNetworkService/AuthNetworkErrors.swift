//
//  AuthNetworkErrors.swift
//  Dolphin
//
//  Created by Иван Медведев on 14.10.2020.
//

import Foundation

enum AuthNetworkErrors: Error
{
	case wrongURL, badResponse, badUserData, noConnection, dataTaskError
}
