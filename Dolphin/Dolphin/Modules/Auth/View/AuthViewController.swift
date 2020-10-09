//
//  AuthViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit

final class AuthViewController: UIViewController
{
	private let presenter: IAuthPresenter

	init(presenter: IAuthPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .lightGray
	}
}

// MARK: - IAuthViewController
extension AuthViewController: IAuthViewController
{
}
