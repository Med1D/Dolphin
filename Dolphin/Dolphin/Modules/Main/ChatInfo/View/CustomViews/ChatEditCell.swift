//
//  ChatEditCell.swift
//  Dolphin
//
//  Created by Иван Медведев on 30.11.2020.
//

import UIKit
import SnapKit

final class ChatEditCell: UITableViewCell
{
// MARK: - UI properties
	let chatImageView = UIImageView()
	let stackView = UIStackView()
	let titleLabel = UILabel()
	let chatTitleTextField = TextFieldWithInsets()
	let activityIndicator = UIActivityIndicatorView(style: .medium)

// MARK: - init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		self.backgroundColor = .white
		self.setupProfileImageView()
		self.setupTitleLabel()
		self.setupChatTitleTextField()
		self.setupStackView()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.contentView.layoutIfNeeded()
		self.chatImageView.layer.cornerRadius = self.chatImageView.frame.height / 2
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatEditCell
{
	func setupProfileImageView() {
		self.contentView.addSubview(self.chatImageView)
		self.chatImageView.clipsToBounds = true
		self.chatImageView.contentMode = .scaleAspectFill
		self.chatImageView.isUserInteractionEnabled = true
		self.activityIndicator.color = .white
		self.activityIndicator.isHidden = true
		self.chatImageView.addSubview(self.activityIndicator)
	}

	func setupTitleLabel() {
		self.titleLabel.text = "Title"
		self.titleLabel.font = MainConstants.helveticaNeueMedium16
	}

	func setupChatTitleTextField() {
		self.chatTitleTextField.placeholder = "Enter title..."
		self.chatTitleTextField.backgroundColor = MainConstants.chatTitleTextFieldColor
		self.chatTitleTextField.clipsToBounds = true
		self.chatTitleTextField.layer.cornerRadius = 10
		self.chatTitleTextField.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
	}

	func setupStackView() {
		self.contentView.addSubview(self.stackView)
		self.stackView.addArrangedSubview(self.titleLabel)
		self.stackView.addArrangedSubview(self.chatTitleTextField)
		self.stackView.axis = .vertical
		self.stackView.spacing = 8
	}

	func setupConstraints() {
		self.chatImageView.snp.makeConstraints { make in
			make.leading.equalTo(self.contentView.snp.leading).offset(16)
			make.centerY.equalTo(self.contentView.snp.centerY)
			make.height.width.equalTo(80)
		}

		self.activityIndicator.snp.makeConstraints { make in
			make.center.equalTo(self.chatImageView.snp.center)
		}

		self.stackView.snp.makeConstraints { make in
			make.centerY.equalTo(self.contentView.snp.centerY)
			make.leading.equalTo(self.chatImageView.snp.trailing).offset(16)
			make.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
		}

		self.chatTitleTextField.snp.makeConstraints { make in
			make.height.equalTo(44)
		}
	}
}
