//
//  NewProfileData.swift
//  Dolphin
//
//  Created by Иван Медведев on 27.11.2020.
//

import Foundation

struct NewProfileData: Codable
{
	let username: String
	let email: String
	let password: String
	let image: NewImage
}

struct NewImage: Codable
{
	let encodedImage: String?
	let isDefaultImage: Bool?

	private enum CodingKeys: String, CodingKey
	{
		case encodedImage
		case isDefaultImage = "setDefaultImage"
	}
}
