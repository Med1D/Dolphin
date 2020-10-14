//
//  ISignUpInteractor.swift
//  Dolphin
//
//  Created by Иван Медведев on 11.10.2020.
//

import Foundation

protocol ISignUpInteractor: AnyObject
{
	func touchSignUpButton(user: User, completion: @escaping (RegisterResult) -> Void)
}
