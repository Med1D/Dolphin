//
//  DolphinMessage.swift
//  Dolphin
//
//  Created by Иван Медведев on 08.12.2020.
//

import Foundation

struct DolphinMessage: Decodable
{
	var id: Int
	var text: String
	var messageType: String
	var sendTimestamp: Int
	var encodedData: String?
	var senderId: Int
}
