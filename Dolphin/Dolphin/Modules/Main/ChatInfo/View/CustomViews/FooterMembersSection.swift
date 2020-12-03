//
//  FooterMembersSection.swift
//  Dolphin
//
//  Created by Иван Медведев on 01.12.2020.
//

import UIKit
import SnapKit

final class FooterMembersSection: UIView
{
// MARK: - UI properties
	private let errorLabel = UILabel()

// MARK: - init
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .white
		self.setupErrorLabel()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private methods (Setup UI)
private extension FooterMembersSection
{
	func setupErrorLabel() {
		self.addSubview(self.errorLabel)
		if let font = MainConstants.helveticaNeueLight14 {
			self.errorLabel.font = font
		}
		self.errorLabel.textColor = .lightGray
	}

	func setupConstraints() {
		self.errorLabel.snp.makeConstraints { make in
			make.center.equalTo(self.snp.center)
		}
	}
}

// MARK: - Methods
extension FooterMembersSection
{
	func configure(withError errorString: String) {
		self.errorLabel.text = errorString
	}
}
