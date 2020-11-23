//
//  ChatNetworkErrors.swift
//  Dolphin
//
//  Created by Иван Медведев on 22.11.2020.
//

import Foundation

enum ChatNetworkErrors: Error
{
	case wrongURL, badResponse, noConnection, dataTaskError
}
