//
//  IAuthNetworkService.swift
//  Dolphin
//
//  Created by Иван Медведев on 14.10.2020.
//

import Foundation

protocol IAuthNetworkService
{
	func register(user: User, completion: @escaping (RegisterResult) -> Void)
}
