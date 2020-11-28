//
//  UIAlertController+extension.swift
//  Dolphin
//
//  Created by Иван Медведев on 26.11.2020.
//

import UIKit

extension UIAlertController
{
	func removeNegativeWidthConstraints() {
		for subView in self.view.subviews {
			for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
				subView.removeConstraint(constraint)
			}
		}
	}
}
