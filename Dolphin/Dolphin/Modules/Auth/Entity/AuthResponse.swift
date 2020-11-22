//
//  AuthResponse.swift
//  Dolphin
//
//  Created by Иван Медведев on 17.10.2020.
//

import Foundation

struct AuthResponse: Decodable
{
	let token: AuthToken
	let user: AuthUser
}

struct AuthToken: Decodable
{
	let token: String
	let userId: Int
}

struct AuthUser: Decodable
{
	let id: Int
	let username: String
	let email: String
	let encodedImage: String?
}
