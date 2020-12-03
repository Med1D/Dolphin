//
//  ChatMember.swift
//  Dolphin
//
//  Created by Иван Медведев on 01.12.2020.
//

import Foundation

struct ChatMember: Decodable
{
	let id: Int
	let username: String
	let email: String
	let encodedImage: String?
}
