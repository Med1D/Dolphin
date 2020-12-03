//
//  LeaveCell.swift
//  Dolphin
//
//  Created by Иван Медведев on 01.12.2020.
//

import UIKit
import SnapKit

final class LeaveCell: UITableViewCell
{
// MARK: - UI properties
	private let leaveLabel = UILabel()

// MARK: - init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .gray
		self.setupLeaveLabel()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private methods (Setup UI)
private extension LeaveCell
{
	func setupLeaveLabel() {
		self.addSubview(self.leaveLabel)
		if let font = MainConstants.helveticaNeueMedium16 {
			self.leaveLabel.font = font
		}
		self.leaveLabel.textColor = .systemRed
		self.leaveLabel.text = "Leave chat"
	}

	func setupConstraints() {
		self.leaveLabel.snp.makeConstraints { make in
			make.center.equalTo(self.snp.center)
		}
	}
}
