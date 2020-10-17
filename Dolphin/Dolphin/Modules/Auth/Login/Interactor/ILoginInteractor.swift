//
//  ILoginInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import Foundation

protocol ILoginInteractor: AnyObject
{
	func auth(user: User, completion: @escaping (AuthResult) -> Void)
}
