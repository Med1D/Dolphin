//
//  IChatListPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

protocol IChatListPresenter: AnyObject
{
	func selectChatRoom(closure: (UIViewController) -> Void)
}
