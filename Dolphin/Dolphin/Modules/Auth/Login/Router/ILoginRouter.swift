//
//  ILoginRouter.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

protocol ILoginRouter: AnyObject
{
	func touchSignUpButton(closure: (UIViewController) -> Void)
}
