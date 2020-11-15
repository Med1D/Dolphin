//
//  LogoutCell.swift
//  Dolphin
//
//  Created by Иван Медведев on 15.11.2020.
//

import UIKit
import SnapKit

final class LogoutCell: UITableViewCell
{
// MARK: - UI properties
	private let logoutLabel = UILabel()

// MARK: - init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .gray
		self.setupLogoutLabel()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private methods (Setup UI)
private extension LogoutCell
{
	func setupLogoutLabel() {
		self.addSubview(self.logoutLabel)
		if let font = MainConstants.helveticaNeueMedium16 {
			self.logoutLabel.font = font
		}
		self.logoutLabel.textColor = .systemRed
		self.logoutLabel.text = "Logout account"
	}

	func setupConstraints() {
		self.logoutLabel.snp.makeConstraints { make in
			make.center.equalTo(self.snp.center)
		}
	}
}
