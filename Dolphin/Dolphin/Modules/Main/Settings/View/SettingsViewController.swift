//
//  SettingsViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 23.10.2020.
//

import UIKit

final class SettingsViewController: UIViewController
{
// MARK: - Properties
	private let presenter: ISettingsPresenter

// MARK: - UI properties

// MARK: - Init
	init(presenter: ISettingsPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

// MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .systemGroupedBackground
		self.title = "Settings"
	}
}

// MARK: - Private methods (Setup UI)
private extension SettingsViewController
{
}

// MARK: - Private methods
private extension SettingsViewController
{
}

// MARK: - ISettingsViewController
extension SettingsViewController: ISettingsViewController
{
}
