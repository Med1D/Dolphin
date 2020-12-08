//
//  MessageKitEntities.swift
//  Dolphin
//
//  Created by Иван Медведев on 07.12.2020.
//

import MessageKit

struct MessageSender: SenderType
{
	var senderId: String
	var displayName: String
}

struct Message: MessageType
{
	var sender: SenderType
	var messageId: String
	var sentDate: Date
	var kind: MessageKind
}
