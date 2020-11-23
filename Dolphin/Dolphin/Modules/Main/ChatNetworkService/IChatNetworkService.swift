//
//  IChatNetworkService.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import Foundation

protocol IChatNetworkService
{
	func getChatRooms(token: String, completion: @escaping (ChatRoomsResult) -> Void)
}
