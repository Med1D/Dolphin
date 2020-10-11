//
//  AuthTextField.swift
//  Dolphin
//
//  Created by Иван Медведев on 11.10.2020.
//

import UIKit
import SkyFloatingLabelTextField

final class AuthTextField: SkyFloatingLabelTextFieldWithIcon
{
	convenience init(type: AuthTextFieldType, placeholder: String, title: String, imageName: String) {
		self.init()
		switch type {
		case .email:
			self.textContentType = .emailAddress
			self.autocorrectionType = .no
		case .password:
			self.isSecureTextEntry = true
			self.textContentType = .password
		}
		self.placeholder = placeholder
		self.placeholderColor = AuthConstants.placeholderColor
		self.title = title
		self.titleColor = AuthConstants.textColor
		self.selectedTitleColor = AuthConstants.textColor
		self.textColor = AuthConstants.textColor
		self.tintColor = AuthConstants.textColor
		self.iconType = .image
		self.iconImage = UIImage(systemName: imageName)
		self.iconColor = AuthConstants.iconColor
		self.selectedIconColor = AuthConstants.iconColor
		self.iconMarginBottom = AuthConstants.iconMarginBottom
		self.iconMarginLeft = AuthConstants.iconMarginLeft
		self.lineHeight = AuthConstants.lineHeight
		self.selectedLineHeight = AuthConstants.lineHeight
		self.lineColor = AuthConstants.lineColor
		self.selectedLineColor = AuthConstants.lineColor
		self.autocapitalizationType = .none
	}
}