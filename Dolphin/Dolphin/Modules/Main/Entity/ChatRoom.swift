//
//  ChatRoom.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

struct ChatRoom: Decodable
{
	let chatRoomData: ChatRoomData
	let lastMessage: LastMessage?

	private enum CodingKeys: String, CodingKey
	{
		case chatRoomData = "room"
		case lastMessage
	}
}

struct ChatRoomData: Decodable
{
	let id: Int
	let title: String
	let encodedImage: String?
}

struct LastMessage: Decodable
{
	let messageData: MessageData
	let sender: Sender

	private enum CodingKeys: String, CodingKey
	{
		case messageData = "message"
		case sender
	}
}

struct MessageData: Decodable
{
	let text: String
	let messageType: String
	let sendTimestamp: Int
}

struct Sender: Decodable
{
	let username: String
}
