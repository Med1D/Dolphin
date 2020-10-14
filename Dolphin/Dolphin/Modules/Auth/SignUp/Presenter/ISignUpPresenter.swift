//
//  ISignUpPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 11.10.2020.
//

import UIKit

protocol ISignUpPresenter: AnyObject
{
	func touchSignUpButton(user: User, completion: @escaping (RegisterResult) -> Void)
}
