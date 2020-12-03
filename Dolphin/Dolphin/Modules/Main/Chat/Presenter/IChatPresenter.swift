//
//  IChatPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

protocol IChatPresenter: AnyObject
{
	func getChatRoomData() -> ChatRoomData
	func openChatInfo(closure: (UIViewController) -> Void)
}
