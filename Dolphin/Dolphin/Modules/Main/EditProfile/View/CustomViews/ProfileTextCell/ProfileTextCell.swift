//
//  ProfileTextCell.swift
//  Dolphin
//
//  Created by Иван Медведев on 26.11.2020.
//

import UIKit
import SnapKit

final class ProfileTextCell: UITableViewCell
{
// MARK: - Properties
	var height: CGFloat {
		return self.label.frame.height + self.textField.frame.height + MainConstants.spaceBetweenLabelAndTextField
	}

// MARK: - UI properties
	let label = UILabel()
	let textField = UITextField()

// MARK: - init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		self.backgroundColor = .white
		self.setupLabel()
		self.setupTextField()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private methods (Setup UI)
private extension ProfileTextCell
{
	func setupLabel() {
		self.contentView.addSubview(self.label)
		self.label.font = MainConstants.helveticaNeueMedium20
		self.label.numberOfLines = 1
	}

	func setupTextField() {
		self.contentView.addSubview(self.textField)
		self.textField.font = MainConstants.helveticaNeue20
		self.textField.autocorrectionType = .no
	}

	func setupConstraints() {
		self.label.snp.makeConstraints { make in
			make.leading.equalTo(self.contentView.snp.leading).offset(MainConstants.profileTextCellLeadingAndTrailingOffset)
			make.top.equalTo(self.contentView.snp.top).offset(8)
		}

		self.textField.snp.makeConstraints { make in
			make.leading.equalTo(self.contentView.snp.leading).offset(MainConstants.profileTextCellLeadingAndTrailingOffset)
			make.bottom.equalTo(self.contentView.snp.bottom).offset(-4)
			make.trailing.equalTo(self.contentView.snp.trailing).offset(-MainConstants.profileTextCellLeadingAndTrailingOffset)
		}
	}
}
