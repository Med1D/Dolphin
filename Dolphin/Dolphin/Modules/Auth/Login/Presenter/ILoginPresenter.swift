//
//  ILoginPresenter.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

protocol ILoginPresenter: AnyObject
{
	func touchLoginButton()
	func touchForgotPasswordButton(closure: @escaping (UIViewController) -> Void)
	func touchSignUpButton(closure: @escaping (UIViewController) -> Void)
}
