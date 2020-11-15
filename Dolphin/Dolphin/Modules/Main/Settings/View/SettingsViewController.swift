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
	private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
	private let logoutCell = LogoutCell()
	private let activityIndicator = UIActivityIndicatorView(style: .medium)
	private let activityView = UIView()

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
		self.title = "Settings"
		self.setupNavigationController()
		self.setupTableView()
		self.setupActivityIndicatorAndActivityView()
		self.setupConstraints()
	}
}

// MARK: - Private methods (Setup UI)
private extension SettingsViewController
{
	func setupNavigationController() {
		navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "",
																						 style: .plain,
																						 target: nil,
																						 action: nil)
	}

	func setupTableView() {
		self.view.addSubview(self.tableView)
		self.tableView.frame = self.view.bounds
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.tableFooterView = UIView()
		self.tableView.backgroundColor = .systemGroupedBackground
	}

	func setupActivityIndicatorAndActivityView() {
		self.tabBarController?.view.addSubview(self.activityView)
		self.activityView.addSubview(self.activityIndicator)
		self.activityView.frame = self.view.bounds
		self.activityView.backgroundColor = MainConstants.activityViewColor
		self.activityView.isHidden = true
		self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		self.activityIndicator.color = .white
		self.activityIndicator.isHidden = true
	}

	func setupConstraints() {
		self.activityIndicator.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}

	func createAlertController(title: String,
							   message: String,
							   actionTitle: String,
							   actionStyle: UIAlertAction.Style,
							   withCancel cancel: Bool,
							   handler: ((UIAlertAction) -> Void)? = nil) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			if cancel {
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				alert.addAction(cancelAction)
			}
			let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: handler)
			alert.addAction(action)
			self.present(alert, animated: true)
		}
	}

	func startActivityIndicator() {
		DispatchQueue.main.async {
			self.navigationController?.view.isUserInteractionEnabled = false
			self.tabBarController?.view.isUserInteractionEnabled = false
			self.activityView.isHidden = false
			self.activityIndicator.startAnimating()
			self.activityIndicator.isHidden = false
		}
	}

	func stopActivityIndicator() {
		DispatchQueue.main.async {
			self.navigationController?.view.isUserInteractionEnabled = true
			self.tabBarController?.view.isUserInteractionEnabled = true
			self.activityView.isHidden = true
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
		}
	}
}

// MARK: - Private methods
private extension SettingsViewController
{
	func touchLogoutButton() {
		self.createAlertController(title: "Log out",
								   message: "Are you sure want to log out?",
								   actionTitle: "Log out",
								   actionStyle: .destructive,
								   withCancel: true) { _ in
			self.presenter.touchLogoutButton { result in
				self.startActivityIndicator()
				switch result {
				case .success:
					self.stopActivityIndicator()
				case .failure(let error):
					self.stopActivityIndicator()
					guard let error = error as? SettingsNetworkErrors else {
						return
					}
					switch error {
					case .noConnection:
						self.createAlertController(title: "No Connection",
												   message: "Failed to access the service.",
												   actionTitle: "OK",
												   actionStyle: .default,
												   withCancel: false)
					default:
						self.createAlertController(title: "Log out Failed",
												   message: "Failed to access the service.",
												   actionTitle: "OK",
												   actionStyle: .default,
												   withCancel: false)
					}
				}
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource
{
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		default:
			return 0
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				return self.logoutCell
			default:
				fatalError("Unknown cell")
			}
		default:
			fatalError("Unknown section")
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch section {
		case 0:
			let view = UIView()
			view.backgroundColor = .systemGroupedBackground
			return view
		default:
			fatalError("Unknown section")
		}
	}
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch section {
		case 0:
			return MainConstants.settingsSectionSpacer
		default:
			fatalError("Unknown section")
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				self.touchLogoutButton()
				self.tableView.deselectRow(at: indexPath, animated: true)
			default:
				fatalError("Unknown cell")
			}
		default:
			fatalError("Unknown section")
		}
	}
}

// MARK: - ISettingsViewController
extension SettingsViewController: ISettingsViewController
{
}
