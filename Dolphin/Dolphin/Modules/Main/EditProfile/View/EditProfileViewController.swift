//
//  EditProfileViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 25.11.2020.
//

import UIKit

final class EditProfileViewController: UIViewController
{
// MARK: - Properties
	private let presenter: IEditProfilePresenter
	private var isDefaultImage = false

// MARK: - UI properties
	private let tableView = UITableView(frame: CGRect.zero, style: .plain)
	private let profileImageCell = ProfileImageCell()
	private let profileNameCell = ProfileTextCell()
	private let profileEmailCell = ProfileTextCell()
	private let profilePasswordCell = ProfileTextCell()
	private let activityIndicator = UIActivityIndicatorView(style: .medium)
	private let activityView = UIView()

// MARK: - Init
	init(presenter: IEditProfilePresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

// MARK: - Deinit
	deinit {
		self.activityIndicator.removeFromSuperview()
		self.activityView.removeFromSuperview()
	}

// MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Edit profile"
		self.setupNavigationController()
		self.setupTableView()
		self.configureProfileImageCell()
		self.configureProfileNameCell()
		self.configureProfileEmailCell()
		self.configureProfilePasswordCell()
		self.setupActivityIndicatorAndActivityView()
		self.setupConstraints()
	}
}

// MARK: - Private methods (Setup UI)
private extension EditProfileViewController
{
	func setupNavigationController() {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: MainConstants.saveBarButton,
																 style: .done,
																 target: self,
																 action: #selector(touchSaveButton))
	}

	func setupTableView() {
		self.view.addSubview(self.tableView)
		self.tableView.frame = self.view.bounds
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = .white
		self.tableView.separatorInset.left = MainConstants.profileTextCellLeadingAndTrailingOffset
		self.tableView.separatorInset.right = MainConstants.profileTextCellLeadingAndTrailingOffset
		self.tableView.bounces = false
		self.tableView.tableFooterView = UIView()
	}

	func configureProfileImageCell() {
		self.profileImageCell.separatorInset.left = self.view.frame.width
		self.profileImageCell.delegate = self
		self.presenter.getProfileImage { string in
			if let image = UIImage.decodeImageFromBase64String(string: string) {
				self.profileImageCell.profileImageView.image = image
				self.isDefaultImage = false
			}
			else {
				self.profileImageCell.profileImageView.image = MainConstants.profileDefaultImage
				self.isDefaultImage = true
			}
		}
	}

	func configureProfileNameCell() {
		self.profileNameCell.label.text = "Name"
		self.profileNameCell.label.sizeToFit()
		self.profileNameCell.textField.placeholder = "Enter name..."
		self.profileNameCell.textField.sizeToFit()
		self.profileNameCell.textField.delegate = self
		self.profileNameCell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		self.profileNameCell.textField.autocapitalizationType = .words
		self.presenter.getProfileName { string in
			if let name = string {
				self.profileNameCell.textField.text = name
			}
		}
	}

	func configureProfileEmailCell() {
		self.profileEmailCell.label.text = "Email"
		self.profileEmailCell.label.sizeToFit()
		self.profileEmailCell.textField.placeholder = "Enter email..."
		self.profileEmailCell.textField.sizeToFit()
		self.profileEmailCell.textField.delegate = self
		self.profileEmailCell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		self.profileEmailCell.textField.autocapitalizationType = .none
		self.presenter.getProfileEmail { string in
			if let email = string {
				self.profileEmailCell.textField.text = email
			}
		}
	}

	func configureProfilePasswordCell() {
		self.profilePasswordCell.label.text = "Password"
		self.profilePasswordCell.label.sizeToFit()
		self.profilePasswordCell.textField.placeholder = "Enter password..."
		self.profilePasswordCell.textField.sizeToFit()
		self.profilePasswordCell.textField.delegate = self
		self.profilePasswordCell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		self.profilePasswordCell.textField.autocapitalizationType = .none
		self.profilePasswordCell.textField.isSecureTextEntry = true
		self.presenter.getProfilePassword { string in
			if let password = string {
				self.profilePasswordCell.textField.text = password
			}
		}
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
		self.navigationController?.view.isUserInteractionEnabled = false
		self.tabBarController?.view.isUserInteractionEnabled = false
		self.activityView.isHidden = false
		self.activityIndicator.startAnimating()
		self.activityIndicator.isHidden = false
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
private extension EditProfileViewController
{
	@objc func touchSaveButton() {
		self.startActivityIndicator()
		let encodedImage = UIImage.encodeImageToBase64String(image: self.profileImageCell.profileImageView.image)
		let newProfileImage = NewProfileImage(encodedImage: encodedImage, isDefaultImage: self.isDefaultImage)
		guard let username = self.profileNameCell.textField.text,
			  let email = self.profileEmailCell.textField.text,
			  let password = self.profilePasswordCell.textField.text else {
			return
		}
		let newProfileData = NewProfileData(username: username,
											email: email,
											password: password,
											image: newProfileImage)
		self.presenter.update(newProfileData: newProfileData) { result in
			switch result {
			case .success:
				self.stopActivityIndicator()
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true)
				}
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
					self.createAlertController(title: "Save Failed",
											   message: "Failed to access the service.",
											   actionTitle: "OK",
											   actionStyle: .default,
											   withCancel: false)
				}
			}
		}
	}

	@objc func textFieldDidChange(_ textField: UITextField) {
		if textField == self.profileEmailCell.textField, let text = textField.text {
			if self.validateEmail(candidate: text) || text.isEmpty {
				self.profileEmailCell.label.textColor = .black
			}
			else {
				self.profileEmailCell.label.textColor = .red
			}
		}
		guard self.profileNameCell.textField.text?.isEmpty == false,
			  self.profileEmailCell.textField.text?.isEmpty == false,
			  let text = self.profileEmailCell.textField.text,
			  self.validateEmail(candidate: text),
			  self.profilePasswordCell.textField.text?.isEmpty == false else {
			self.navigationItem.rightBarButtonItem?.isEnabled = false
			return
		}
		self.navigationItem.rightBarButtonItem?.isEnabled = true
	}

	func validateEmail(candidate: String) -> Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
	}
}

// MARK: - UITableViewDataSource
extension EditProfileViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			return self.profileImageCell
		case 1:
			return self.profileNameCell
		case 2:
			return self.profileEmailCell
		case 3:
			return self.profilePasswordCell
		default:
			fatalError("Unknown cell")
		}
	}
}

// MARK: - UITableViewDelegate
extension EditProfileViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return 150
		case 1:
			return self.profileNameCell.height
		case 2:
			return self.profileEmailCell.height
		case 3:
			return self.profilePasswordCell.height
		default:
			fatalError("Unknown cell")
		}
	}
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - ProfileImageCellDelegate
extension EditProfileViewController: ProfileImageCellDelegate
{
	func touchProfileImageCell() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let changeImageAction = UIAlertAction(title: "Change image", style: .default) { _ in
			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
				let imagePicker = UIImagePickerController()
				imagePicker.delegate = self
				imagePicker.sourceType = .photoLibrary
				imagePicker.allowsEditing = true
				self.present(imagePicker, animated: true)
			}
		}
		let deleteImageAction = UIAlertAction(title: "Delete image", style: .destructive) { _ in
			self.profileImageCell.profileImageView.image = MainConstants.profileDefaultImage
			self.isDefaultImage = true
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
		}
		alertController.addAction(changeImageAction)
		alertController.addAction(deleteImageAction)
		alertController.addAction(cancelAction)
		alertController.removeNegativeWidthConstraints()
		self.present(alertController, animated: true)
	}
}

// MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		picker.delegate = nil
		guard let image = info[.editedImage] as? UIImage else {
			return
		}
		self.profileImageCell.profileImageView.image = image
		self.isDefaultImage = false
		picker.dismiss(animated: true)
	}
}

// MARK: - IEditProfileViewController
extension EditProfileViewController: IEditProfileViewController
{
}
