//
//  ChatRoomCell.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit
import SnapKit

final class ChatRoomCell: UITableViewCell
{
// MARK: - Properties
	static let cellReuseIdentifier = "cell"
	var chatRoom: ChatRoom? {
		didSet {
			self.setImage()
			self.chatRoomName.text = chatRoom?.chatRoomData.title
			self.setLastMessageWithHighlightedSenderName()
			self.setLastMessageTime()
		}
	}

// MARK: - UI properties
	private let chatRoomImageView = UIImageView()
	private let chatRoomName = UILabel()
	private let lastMessage = UILabel()
	private let lastMessageTime = UILabel()

// MARK: - init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		self.setupChatRoomImageView()
		self.setupChatRoomName()
		self.setupLastMessage()
		self.setupLastMessageTime()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

// MARK: - LayoutSubviews
	override func layoutSubviews() {
		super.layoutSubviews()
		self.chatRoomImageView.layer.cornerRadius = self.chatRoomImageView.bounds.width / 2
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatRoomCell
{
	func setupChatRoomImageView() {
		self.addSubview(self.chatRoomImageView)
		self.chatRoomImageView.contentMode = .scaleAspectFill
		self.chatRoomImageView.clipsToBounds = true
	}

	func setupChatRoomName() {
		self.addSubview(self.chatRoomName)
		if let font = MainConstants.helveticaNeueMedium16 {
			self.chatRoomName.font = font
		}
	}

	func setupLastMessage() {
		self.addSubview(self.lastMessage)
		self.lastMessage.textColor = .lightGray
		self.lastMessage.numberOfLines = 2
		if let font = MainConstants.helveticaNeue14 {
			self.lastMessage.font = font
		}
	}

	func setupLastMessageTime() {
		self.addSubview(self.lastMessageTime)
		if let font = MainConstants.helveticaNeueLight14 {
			self.lastMessageTime.font = font
		}
	}

	func setupConstraints() {
		self.chatRoomImageView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(MainConstants.imageLeadingOffset)
			make.top.equalToSuperview().offset(MainConstants.imageTopOffset)
			make.bottom.equalToSuperview().offset(-MainConstants.imageBottomOffset)
			make.width.height.equalTo(MainConstants.imageSize)
		}

		self.lastMessageTime.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(MainConstants.imageTopOffset)
			make.trailing.equalToSuperview().offset(-MainConstants.messageTimeOffset)
		}

		self.chatRoomName.snp.makeConstraints { make in
			make.leading.equalTo(self.chatRoomImageView.snp.trailing).offset(MainConstants.imageLeadingOffset)
			make.trailing.equalToSuperview().offset(-MainConstants.messageAndNameTrailingOffset)
			make.top.equalToSuperview().offset(MainConstants.imageTopOffset)
		}

		self.lastMessage.snp.makeConstraints { make in
			make.leading.equalTo(self.chatRoomImageView.snp.trailing).offset(MainConstants.imageLeadingOffset)
			make.trailing.equalToSuperview().offset(-MainConstants.messageAndNameTrailingOffset)
			make.top.equalTo(self.chatRoomName.snp.bottom).offset(4)
		}
	}
}

// MARK: - Private Methods
private extension ChatRoomCell
{
	func setImage() {
		if let encodedImage = chatRoom?.chatRoomData.encodedImage,
		   encodedImage.isEmpty == false,
		   let imageData = Data(base64Encoded: encodedImage) {
			let image = UIImage(data: imageData)
			self.chatRoomImageView.image = image
		}
		else {
			self.chatRoomImageView.image = MainConstants.chatRoomDefaultImage
		}
	}

	func setLastMessageWithHighlightedSenderName() {
		if let senderName = chatRoom?.lastMessage?.sender.username,
		   let text = chatRoom?.lastMessage?.messageData.text {
			if chatRoom?.lastMessage?.messageData.messageType == "text" {
				let attrubutedText = NSMutableAttributedString(string: senderName + ": " + text)
				attrubutedText.addAttribute(.foregroundColor,
											value: UIColor.black,
											range: NSRange(location: 0,
														   length: senderName.count + 1))
				self.lastMessage.attributedText = attrubutedText
			}
			else if chatRoom?.lastMessage?.messageData.messageType == "photo" {
				let attrubutedText = NSMutableAttributedString(string: senderName + ": photo")
				attrubutedText.addAttribute(.foregroundColor,
											value: UIColor.black,
											range: NSRange(location: 0,
														   length: senderName.count + 1))
				self.lastMessage.attributedText = attrubutedText
			}
			else {
				self.lastMessage.text = ""
			}
		}
	}

	func setLastMessageTime() {
		if let timestamp = chatRoom?.lastMessage?.messageData.sendTimestamp {
			let timeInterval = TimeInterval(timestamp)
			let sendTimeDate = Date(timeIntervalSince1970: timeInterval)
			let dateFormatter = DateFormatter()
			let calendar = Calendar.current
			dateFormatter.locale = .current
			if calendar.isDateInToday(sendTimeDate) {
				dateFormatter.setLocalizedDateFormatFromTemplate("HHmm")
			}
			else {
				dateFormatter.setLocalizedDateFormatFromTemplate("MMdd")
			}
			let sendTimeString = dateFormatter.string(from: sendTimeDate)
			self.lastMessageTime.text = sendTimeString
		}
	}
}

// MARK: - Methods
extension ChatRoomCell
{
	func setHighlighted(is bool: Bool) {
		if bool {
			self.backgroundColor = MainConstants.highlightedCellColor
			self.chatRoomName.textColor = .white
			self.lastMessage.textColor = .white
			self.lastMessageTime.textColor = .white
		}
		else {
			self.backgroundColor = .white
			self.chatRoomName.textColor = .black
			self.lastMessage.textColor = .lightGray
			self.setLastMessageWithHighlightedSenderName()
			self.lastMessageTime.textColor = .black
		}
	}
}
