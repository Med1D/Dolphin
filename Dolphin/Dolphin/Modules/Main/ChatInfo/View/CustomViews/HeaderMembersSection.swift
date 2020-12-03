//
//  HeaderMembersSection.swift
//  Dolphin
//
//  Created by Иван Медведев on 01.12.2020.
//

import UIKit
import SnapKit

final class HeaderMembersSection: UIView
{
// MARK: - properties
	var count: Int = 0 {
		didSet {
			self.activityIndicator.isHidden = true
			self.activityIndicator.stopAnimating()
			self.setupMembersLabel(count: self.count)
		}
	}
// MARK: - UI properties
	private let membersLabel = UILabel()
	private let activityIndicator = UIActivityIndicatorView(style: .medium)

// MARK: - init
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .white
		self.activityIndicator.startAnimating()
		self.activityIndicator.isHidden = false
		self.setupMembersLabel()
		self.setupActivityIndicator()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private methods (Setup UI)
private extension HeaderMembersSection
{
	func setupMembersLabel(count: Int? = nil) {
		self.addSubview(self.membersLabel)
		if let font = MainConstants.helveticaNeueMedium16 {
			self.membersLabel.font = font
		}
		if let count = count {
			let membersString = "Members "
			let countString = "\(count)"
			let attributedString = NSMutableAttributedString(string: membersString + countString)
			attributedString.addAttribute(.font,
										  value: MainConstants.helveticaNeueMedium16 ?? UIFont.systemFont(ofSize: 16),
										  range: NSRange(location: 0, length: membersString.count))
			attributedString.addAttribute(.foregroundColor,
										  value: UIColor.black,
										  range: NSRange(location: 0, length: membersString.count))
			attributedString.addAttribute(.font,
										  value: MainConstants.helveticaNeue16 ?? UIFont.systemFont(ofSize: 16),
										  range: NSRange(location: membersString.count, length: countString.count))
			attributedString.addAttribute(.foregroundColor,
										  value: UIColor.lightGray,
										  range: NSRange(location: membersString.count, length: countString.count))
			self.membersLabel.attributedText = attributedString
		}
		else {
			self.membersLabel.text = "Members"
		}
	}

	func setupActivityIndicator() {
		self.addSubview(self.activityIndicator)
	}

	func setupConstraints() {
		self.membersLabel.snp.makeConstraints { make in
			make.leading.equalTo(self.snp.leading).offset(16)
			make.centerY.equalTo(self.snp.centerY)
		}

		self.activityIndicator.snp.makeConstraints { make in
			make.leading.equalTo(self.membersLabel.snp.trailing).offset(8)
			make.centerY.equalTo(self.snp.centerY)
		}
	}
}
