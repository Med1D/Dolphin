//
//  User.swift
//  Dolphin
//
//  Created by Иван Медведев on 14.10.2020.
//

import Foundation

struct User: Codable
{
	let login: String
	var email: String
	let password: String
}
