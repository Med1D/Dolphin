//
//  ILoginPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

protocol ILoginPresenter: AnyObject
{
	func touchLoginButton(user: User, completion: @escaping (AuthResult) -> Void)
	func touchForgotPasswordButton(closure: (UIViewController) -> Void)
	func touchSignUpButton(closure: (UIViewController) -> Void)
}
