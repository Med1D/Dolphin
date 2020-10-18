//
//  AuthResponse.swift
//  Dolphin
//
//  Created by Иван Медведев on 17.10.2020.
//

import Foundation

struct AuthResponse: Codable
{
	let userId: Int
	let token: String
}
