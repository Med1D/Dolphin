//
//  ProfileImageCell.swift
//  Dolphin
//
//  Created by Иван Медведев on 26.11.2020.
//

import UIKit
import SnapKit

final class ProfileImageCell: UITableViewCell
{
// MARK: - Properties
	private let tapGestureRecognizer = UITapGestureRecognizer()
	weak var delegate: ProfileImageCellDelegate?

// MARK: - UI properties
	let profileImageView = UIImageView()

// MARK: - init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		self.backgroundColor = .white
		self.configureTapGestureRecognizer()
		self.setupProfileImageView()
		self.setupConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.contentView.layoutIfNeeded()
		self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
	}
}

// MARK: - Private methods (Setup UI)
private extension ProfileImageCell
{
	func configureTapGestureRecognizer() {
		self.tapGestureRecognizer.addTarget(self, action: #selector(touchProfileImageView))
	}

	func setupProfileImageView() {
		self.contentView.addSubview(self.profileImageView)
		self.profileImageView.clipsToBounds = true
		self.profileImageView.addGestureRecognizer(self.tapGestureRecognizer)
		self.profileImageView.contentMode = .scaleAspectFill
		self.profileImageView.isUserInteractionEnabled = true
		self.profileImageView.tintColor = MainConstants.profileImageViewTintColor
	}

	func setupConstraints() {
		self.profileImageView.snp.makeConstraints { make in
			make.center.equalTo(self.contentView.snp.center)
			make.height.width.equalTo(134)
		}
	}
}

// MARK: - Private methods
private extension ProfileImageCell
{
	@objc func touchProfileImageView() {
		self.delegate?.touchProfileImageCell()
	}
}
