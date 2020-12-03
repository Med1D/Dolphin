//
//  TextFieldWithInsets.swift
//  Dolphin
//
//  Created by Иван Медведев on 01.12.2020.
//

import UIKit

final class TextFieldWithInsets: UITextField
{
	var textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.textRect(forBounds: bounds)
		return rect.inset(by: textPadding)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.editingRect(forBounds: bounds)
		return rect.inset(by: textPadding)
	}
}
