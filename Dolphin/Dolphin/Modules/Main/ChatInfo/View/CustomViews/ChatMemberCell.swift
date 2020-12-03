//
//  ChatMemberCell.swift
//  Dolphin
//
//  Created by Иван Медведев on 01.12.2020.
//

import UIKit
import SnapKit

final class ChatMemberCell: UITableViewCell
{
// MARK: - properties
	static let cellReuseIdentifier = "cell"
// MARK: - UI properties
	private let chatMemberImageView = UIImageView()
	private let chatMemberNameLabel = UILabel()

// MARK: - init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		self.backgroundColor = .white
		self.setupChatMemberImageView()
		self.setupChatMemberNameLabel()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

// MARK: - LayoutSubviews
	override func layoutSubviews() {
		super.layoutSubviews()
		self.contentView.layoutIfNeeded()
		self.chatMemberImageView.layer.cornerRadius = self.chatMemberImageView.frame.height / 2
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatMemberCell
{
	func setupChatMemberImageView() {
		self.contentView.addSubview(self.chatMemberImageView)
		self.chatMemberImageView.clipsToBounds = true
		self.chatMemberImageView.contentMode = .scaleAspectFill
		self.chatMemberImageView.tintColor = MainConstants.profileImageViewTintColor
		self.chatMemberImageView.image = nil
	}

	func setupChatMemberNameLabel() {
		self.contentView.addSubview(self.chatMemberNameLabel)
		self.chatMemberNameLabel.text = ""
		self.chatMemberNameLabel.font = MainConstants.helveticaNeue16
	}

	func setupConstraints() {
		self.chatMemberImageView.snp.makeConstraints { make in
			make.leading.equalTo(self.contentView.snp.leading).offset(16)
			make.height.width.equalTo(44)
			make.centerY.equalTo(self.contentView.snp.centerY)
		}

		self.chatMemberNameLabel.snp.makeConstraints { make in
			make.leading.equalTo(self.chatMemberImageView.snp.trailing).offset(16)
			make.centerY.equalTo(self.contentView.snp.centerY)
		}
	}
}

// MARK: - Methods
extension ChatMemberCell
{
	func configure(with chatMember: ChatMember) {
		if let image = UIImage.decodeImageFromBase64String(string: chatMember.encodedImage) {
			self.chatMemberImageView.image = image
		}
		else {
			self.chatMemberImageView.image = MainConstants.profileDefaultImage
		}
		self.chatMemberNameLabel.text = chatMember.username
	}
}
