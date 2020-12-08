//
//  ChatRoomMembersCount.swift
//  Dolphin
//
//  Created by Иван Медведев on 08.12.2020.
//

import Foundation

struct ChatRoomMembersCount: Decodable
{
	let roomId: Int
	let count: Int

	private enum CodingKeys: String, CodingKey
	{
		case roomId
		case count = "userCount"
	}
}
