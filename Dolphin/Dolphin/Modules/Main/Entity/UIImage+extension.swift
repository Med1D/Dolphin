//
//  UIImage+extension.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.11.2020.
//

import UIKit

extension UIImage
{
	static func encodeImageToBase64String(image: UIImage?) -> String? {
		guard let imageData = image?.pngData() else { return nil }
		return imageData.base64EncodedString()
	}

	static func decodeImageFromBase64String(string: String?) -> UIImage? {
		if let encodedImage = string,
		   encodedImage.isEmpty == false,
		   let imageData = Data(base64Encoded: encodedImage) {
			let image = UIImage(data: imageData)
			return image
		}
		else {
			return MainConstants.chatRoomDefaultImage
		}
	}
}
