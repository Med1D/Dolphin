//
//  MainConstants.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

enum MainConstants
{
	static let helveticaNeue14 = UIFont(name: "HelveticaNeue", size: 14)
	static let helveticaNeueLight14 = UIFont(name: "HelveticaNeue-Light", size: 14)
	static let helveticaNeueMedium16 = UIFont(name: "HelveticaNeue-Medium", size: 16)
	static let imageSize: CGFloat = 64
	static let imageTopOffset: CGFloat = 8
	static let imageBottomOffset: CGFloat = 8
	static let imageLeadingOffset: CGFloat = 16
	static let messageTimeOffset: CGFloat = 16
	static let messageAndNameTrailingOffset: CGFloat = 64
	static let highlightedCellColor = UIColor(red: 52 / 255, green: 70 / 255, blue: 93 / 255, alpha: 1)
	static let settingsSectionSpacer: CGFloat = 16
	static let separatorColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1)
	static let activityViewColor = UIColor(red: 52 / 255, green: 70 / 255, blue: 93 / 255, alpha: 0.9)
	static let chatRoomDefaultImage = UIImage(named: "ChatRoomDefaultImage")
	static let sendButtonImage = UIImage(systemName: "arrow.up.circle.fill",
										 withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
	static let sendButtonSize: CGFloat = 36
	static let clipButtonImage = UIImage(systemName: "paperclip",
										 withConfiguration: UIImage.SymbolConfiguration(pointSize: 28))
	static let clipButtonSize: CGFloat = 28
	static let sendButtonTintColor = UIColor(red: 76 / 255, green: 117 / 255, blue: 163 / 255, alpha: 1)
	static let sendButtonTintColorDisabled = UIColor(red: 76 / 255, green: 117 / 255, blue: 163 / 255, alpha: 0.85)
	static let inputTextViewBackgroundColor = UIColor(red: 245 / 255,
													  green: 245 / 255,
													  blue: 245 / 255,
													  alpha: 1)
	static let inputTextViewBorderColor = UIColor(red: 200 / 255,
												  green: 200 / 255,
												  blue: 200 / 255,
												  alpha: 1).cgColor
	static let inputTextViewPlaceholderText = "Message..."
	static let searchBarPlaceholder = "Search"
}
