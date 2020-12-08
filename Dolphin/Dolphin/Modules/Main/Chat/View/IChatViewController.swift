//
//  IChatViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit

protocol IChatViewController: AnyObject
{
	func refreshChatRoomInfo()
	func loadFirstMessages()
	func loadMoreMessages()
	func insertMessage()
}
