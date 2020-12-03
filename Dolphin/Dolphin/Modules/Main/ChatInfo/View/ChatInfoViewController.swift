//
//  ChatInfoViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 30.11.2020.
//

import UIKit

//swiftlint:disable file_length
final class ChatInfoViewController: UIViewController
{
// MARK: - Properties
	private let presenter: IChatInfoPresenter
	private var isDefaultImage = false

// MARK: - UI properties
	private let tableView = UITableView(frame: .zero, style: .plain)
	private let chatEditCell = ChatEditCell()
	private let leaveCell = LeaveCell()
	private let headerMembersSection = HeaderMembersSection()
	private let footerMembersSection = FooterMembersSection()

// MARK: - Init
	init(presenter: IChatInfoPresenter) {
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
		self.title = self.presenter.getChatRoomData().title
		self.setupTableView()
		self.configureChatEditCell()
		self.configureLeaveCell()
		self.presenter.getChatMembersFromService()
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatInfoViewController
{
	func setupTableView() {
		self.view.addSubview(self.tableView)
		self.tableView.frame = self.view.bounds
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.backgroundColor = .white
		self.tableView.tableFooterView = UIView()
		self.tableView.register(ChatMemberCell.self, forCellReuseIdentifier: ChatMemberCell.cellReuseIdentifier)
	}

	func configureChatEditCell() {
		let tapGesutreRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchChatEditCellImageView))
		self.chatEditCell.chatImageView.addGestureRecognizer(tapGesutreRecognizer)
		self.chatEditCell.chatTitleTextField.delegate = self
		self.chatEditCell.separatorInset.left = 0
		let image = UIImage.decodeImageFromBase64String(string: self.presenter.getChatRoomData().encodedImage)
		if let image = image {
			self.chatEditCell.chatImageView.image = image
			self.isDefaultImage = false
		}
		else {
			self.chatEditCell.chatImageView.image = MainConstants.chatRoomDefaultImage
			self.isDefaultImage = true
		}
		self.chatEditCell.chatTitleTextField.text = self.presenter.getChatRoomData().title
	}

	func configureLeaveCell() {
		self.leaveCell.separatorInset.left = 0
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

	func createErrorAlertController(error: ChatNetworkErrors, errorTitle: String) {
		switch error {
		case .noConnection:
			self.createAlertController(title: "No Connection",
									   message: "Failed to access the service.",
									   actionTitle: "OK",
									   actionStyle: .default,
									   withCancel: false)
		default:
			self.createAlertController(title: errorTitle,
									   message: "Failed to access the service.",
									   actionTitle: "OK",
									   actionStyle: .default,
									   withCancel: false)
		}
	}

	func startImageActivityIndicator() {
		self.chatEditCell.activityIndicator.startAnimating()
		self.chatEditCell.activityIndicator.isHidden = false
		self.view.isUserInteractionEnabled = false
	}

	func stopImageActivityIndicator() {
		DispatchQueue.main.async {
			self.chatEditCell.activityIndicator.stopAnimating()
			self.chatEditCell.activityIndicator.isHidden = true
			self.view.isUserInteractionEnabled = true
		}
	}
}

// MARK: - Private methods
private extension ChatInfoViewController
{
	@objc func touchChatEditCellImageView() {
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
			let encodedImage = UIImage.encodeImageToBase64String(image: MainConstants.chatRoomDefaultImage)
			self.isDefaultImage = true
			let newImage = NewImage(encodedImage: encodedImage, isDefaultImage: self.isDefaultImage)
			self.updateChatRoomImage(newImage: newImage)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
		}
		alertController.addAction(changeImageAction)
		alertController.addAction(deleteImageAction)
		alertController.addAction(cancelAction)
		alertController.removeNegativeWidthConstraints()
		self.present(alertController, animated: true)
	}

	func updateChatRoomImage(newImage: NewImage) {
		self.startImageActivityIndicator()
		self.presenter.updateChatRoomImage(newImage: newImage) { result in
			switch result {
			case .success(let newImage):
				let image = UIImage.decodeImageFromBase64String(string: newImage.encodedImage)
				self.presenter.setChatRoomData(title: nil, encodedImage: newImage.encodedImage)
				DispatchQueue.main.async {
					self.chatEditCell.chatImageView.image = image
				}
			case .failure(let error):
				guard let error = error as? ChatNetworkErrors else {
					return
				}
				self.createErrorAlertController(error: error, errorTitle: "Update Failed")
			}
			self.stopImageActivityIndicator()
		}
	}

	func updateChatRoomTitle(newTitle: String) {
		self.presenter.updateChatRoomTitle(newTitle: newTitle) { result in
			switch result {
			case .success(let title):
				self.presenter.setChatRoomData(title: title, encodedImage: nil)
				DispatchQueue.main.async {
					self.title = title
					self.chatEditCell.chatTitleTextField.text = title
				}
			case .failure(let error):
				guard let error = error as? ChatNetworkErrors else {
					return
				}
				self.createErrorAlertController(error: error, errorTitle: "Update Failed")
			}
		}
	}

	func touchLeaveButton() {
		self.createAlertController(title: "Leave chat",
								   message: "Are you sure want to leave?",
								   actionTitle: "Leave",
								   actionStyle: .destructive,
								   withCancel: true) { _ in
			self.presenter.leaveChatRoom { result in
				switch result {
				case .success:
					DispatchQueue.main.async {
						self.navigationController?.popToRootViewController(animated: true)
					}
				case .failure(let error):
					guard let error = error as? ChatNetworkErrors else {
						return
					}
					self.createErrorAlertController(error: error, errorTitle: "Leave Failed")
				}
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension ChatInfoViewController: UITableViewDataSource
{
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 3
		case 1:
			return self.presenter.getChatMembers().count
		default:
			fatalError("Unknown section")
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				return self.chatEditCell
			case 1:
				return self.leaveCell
			case 2:
				return UITableViewCell()
			default:
				fatalError("Unknown cell")
			}
		case 1:
			let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as? ChatMemberCell
			cell?.configure(with: self.presenter.getChatMember(at: indexPath.row))
			cell?.separatorInset.left = self.view.frame.width
			return cell ?? UITableViewCell()
		default:
			fatalError("Unknown seciton")
		}
	}
}

// MARK: - UITableViewDelegate
extension ChatInfoViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 1 {
			return self.headerMembersSection
		}
		else {
			return nil
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 {
			return 44
		}
		else {
			return .leastNormalMagnitude
		}
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if section == 1 {
			return self.footerMembersSection
		}
		else {
			return nil
		}
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if section == 1 {
			return 44
		}
		else {
			return .leastNormalMagnitude
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				return 112
			case 1:
				return 44
			case 2:
				return .leastNormalMagnitude
			default:
				fatalError("Unknown cell")
			}
		case 1:
			return 64
		default:
			fatalError("Unknown section")
		}
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				return 112
			case 1:
				return 44
			case 2:
				return .leastNormalMagnitude
			default:
				fatalError("Unknown cell")
			}
		case 1:
			return 64
		default:
			fatalError("Unknown section")
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 && indexPath.row == 1 {
			self.touchLeaveButton()
			self.tableView.deselectRow(at: indexPath, animated: true)
		}
	}
}

// MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension ChatInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		picker.delegate = nil
		guard let image = info[.editedImage] as? UIImage else {
			return
		}
		self.isDefaultImage = false
		let encodedImage = UIImage.encodeImageToBase64String(image: image)
		let newImage = NewImage(encodedImage: encodedImage, isDefaultImage: self.isDefaultImage)
		self.updateChatRoomImage(newImage: newImage)
		picker.dismiss(animated: true)
	}
}

// MARK: - UITextFieldDelegate
extension ChatInfoViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text else { return true }
		if text.isEmpty {
			self.createAlertController(title: "Error",
									   message: "Title must not be empty.",
									   actionTitle: "OK",
									   actionStyle: .default,
									   withCancel: false)
			textField.text = self.presenter.getChatRoomData().title
		}
		else {
			self.updateChatRoomTitle(newTitle: text)
		}
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - IChatInfoViewController
extension ChatInfoViewController: IChatInfoViewController
{
	func reloadChatMembers() {
		if let error = self.presenter.getError() {
			DispatchQueue.main.async {
				self.footerMembersSection.isHidden = false
				switch error {
				case .noConnection:
					self.footerMembersSection.configure(withError: "No connection")
				default:
					self.footerMembersSection.configure(withError: "Failed to access the service")
				}
			}
		}
		else {
			DispatchQueue.main.async {
				self.footerMembersSection.isHidden = true
				self.footerMembersSection.configure(withError: "")
			}
		}
		DispatchQueue.main.async {
			self.headerMembersSection.count = self.presenter.getChatMembers().count
			self.tableView.reloadData()
		}
	}
}
