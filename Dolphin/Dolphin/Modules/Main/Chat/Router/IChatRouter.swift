//
//  IChatRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

protocol IChatRouter: AnyObject
{
	func openChatInfo(chatRoomData: ChatRoomData, chatDelegate: ChatDelegate, closure: (UIViewController) -> Void)
}
