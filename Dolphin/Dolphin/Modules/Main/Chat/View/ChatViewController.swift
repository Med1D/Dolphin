//
//  ChatViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit
import SnapKit
import MessageKit
import InputBarAccessoryView

final class ChatViewController: MessagesViewController
{
// MARK: - Properties
	private let presenter: IChatPresenter

// MARK: - UI properties
	private let chatImageButtonView = UIView()
	private let chatImageView = UIImageView()
	private let chatTitleView = UIView()
	private let chatTitleLabel = UILabel()
	private let activityIndicator = UIActivityIndicatorView(style: .medium)

// MARK: - Init
	init(presenter: IChatPresenter) {
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
		self.messagesCollectionView.messagesDataSource = self
		self.messagesCollectionView.messagesLayoutDelegate = self
		self.messagesCollectionView.messagesDisplayDelegate = self
		self.setupNavigationController()
		self.setupActivityIndicator()
		self.setupTitleView()
		self.setupChatImageButton()
		self.configureMessageCollectionView()
		self.configureMessageInputBar()
		self.presenter.getChatRoomMembersCount()
		self.presenter.getMessages(page: self.presenter.getPage())
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatViewController
{
	func setupNavigationController() {
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
														   style: .plain,
														   target: nil,
														   action: nil)
	}

	func setupActivityIndicator() {
		self.view.addSubview(self.activityIndicator)
		self.activityIndicator.startAnimating()
		self.activityIndicator.isHidden = false
		self.activityIndicator.snp.makeConstraints { make in
			make.center.equalTo(self.view.snp.center)
		}
	}

	func setupTitleView() {
		self.chatTitleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 44)
		self.chatTitleLabel.numberOfLines = 2
		self.chatTitleLabel.center = self.chatTitleView.center
		self.chatTitleLabel.textAlignment = .center
		self.setupTitle()
		self.chatTitleView.addSubview(self.chatTitleLabel)
		self.navigationItem.titleView = self.chatTitleView
	}

	func setupTitle() {
		let title = self.presenter.getChatRoomData().title
		var attributedText: NSMutableAttributedString
		if let number = self.presenter.getMembersCount() {
			let numberOfMembers = "\(number) members"
			attributedText = NSMutableAttributedString(string: title + "\n" + numberOfMembers)
			attributedText.addAttribute(.foregroundColor,
										value: UIColor.lightGray,
										range: NSRange(location: title.count + 1, length: numberOfMembers.count))
			attributedText.addAttribute(.font,
										value: MainConstants.helveticaNeueLight14 ?? UIFont.systemFont(ofSize: 14),
										range: NSRange(location: title.count + 1, length: numberOfMembers.count))
		}
		else {
			attributedText = NSMutableAttributedString(string: title)
		}
		attributedText.addAttribute(.foregroundColor,
									value: UIColor.black,
									range: NSRange(location: 0, length: title.count))
		attributedText.addAttribute(.font,
									value: MainConstants.helveticaNeueMedium16 ?? UIFont.systemFont(ofSize: 16),
									range: NSRange(location: 0, length: title.count))
		self.chatTitleLabel.attributedText = attributedText
	}

	func setupChatImageButton() {
		let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		self.chatImageButtonView.frame = frame
		self.chatImageView.frame = frame
		self.setupImage()
		self.chatImageView.contentMode = .scaleAspectFill
		self.chatImageView.layer.cornerRadius = frame.height / 2
		self.chatImageView.clipsToBounds = true
		self.chatImageButtonView.addSubview(self.chatImageView)
		let button = UIButton(frame: frame)
		button.addTarget(self, action: #selector(self.touchChatImageButton), for: .touchUpInside)
		button.backgroundColor = .clear
		button.setTitle("", for: .normal)
		self.chatImageButtonView.addSubview(button)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.chatImageButtonView)
	}

	func setupImage() {
		if let image = UIImage.decodeImageFromBase64String(string: self.presenter.getChatRoomData().encodedImage) {
			self.chatImageView.image = image
		}
		else {
			self.chatImageView.image = MainConstants.chatRoomDefaultImage
		}
	}

	func configureMessageCollectionView() {
		let layout = self.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
		layout?.setMessageOutgoingAvatarPosition(.init(vertical: .messageCenter))
		layout?.setMessageIncomingAvatarPosition(.init(vertical: .messageCenter))
		self.scrollsToBottomOnKeyboardBeginsEditing = true
		self.maintainPositionOnKeyboardFrameChanged = true
	}

	func configureMessageInputBar() {
		self.messageInputBar.delegate = self
		self.messageInputBar.separatorLine.isHidden = true
		self.messageInputBar.inputTextView.backgroundColor = MainConstants.inputTextViewBackgroundColor
		self.messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 16)
		self.messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		self.messageInputBar.inputTextView.placeholder = MainConstants.inputTextViewPlaceholderText
		self.messageInputBar.inputTextView.layer.borderColor = MainConstants.inputTextViewBorderColor
		self.messageInputBar.inputTextView.layer.borderWidth = 1.0
		self.messageInputBar.inputTextView.layer.cornerRadius = 16.0
		self.messageInputBar.inputTextView.layer.masksToBounds = true
		self.messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
		self.configureInputBarItems()
	}

	func configureInputBarItems() {
		self.messageInputBar.setLeftStackViewWidthConstant(to: MainConstants.clipButtonSize, animated: false)
		let clipItem = InputBarButtonItem(type: .system)
		clipItem.image = MainConstants.clipButtonImage
		clipItem.tintColor = MainConstants.sendButtonTintColor
		clipItem.imageEdgeInsets = UIEdgeInsets(top: -4, left: -6, bottom: 4, right: 6)
		clipItem.setSize(CGSize(width: MainConstants.clipButtonSize,
								height: MainConstants.clipButtonSize), animated: false)
		self.messageInputBar.setStackViewItems([clipItem], forStack: .left, animated: false)

		self.messageInputBar.setRightStackViewWidthConstant(to: MainConstants.sendButtonSize, animated: false)
		self.messageInputBar.sendButton.setSize(CGSize(width: MainConstants.sendButtonSize,
													   height: MainConstants.sendButtonSize), animated: false)
		self.messageInputBar.sendButton.image = MainConstants.sendButtonImage
		self.messageInputBar.sendButton.title = nil
		self.messageInputBar.sendButton.tintColor = MainConstants.sendButtonTintColorDisabled
		self.messageInputBar.sendButton
			.onEnabled { item in
				UIView.animate(withDuration: 0.3, animations: {
					item.tintColor = MainConstants.sendButtonTintColor
				})
			}
			.onDisabled { item in
				UIView.animate(withDuration: 0.3, animations: {
					item.tintColor = MainConstants.sendButtonTintColorDisabled
				})
			}
		self.messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
	}
}

// MARK: - Private methods
private extension ChatViewController
{
	@objc func touchChatImageButton() {
		self.presenter.openChatInfo { viewController in
			viewController.hidesBottomBarWhenPushed = true
			self.navigationController?.pushViewController(viewController, animated: true)
		}
	}

	func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
		return indexPath.section % 10 == 0 && isPreviousMessageSameSender(at: indexPath) == false
	}

	func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
		guard indexPath.section - 1 >= 0 else { return false }
		return self.presenter.getMessage(at: indexPath.section).sender.senderId ==
			self.presenter.getMessage(at: indexPath.section - 1).sender.senderId
	}

	func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
		guard indexPath.section + 1 < self.presenter.getMessagesCount() else { return false }
		return self.presenter.getMessage(at: indexPath.section).sender.senderId ==
			self.presenter.getMessage(at: indexPath.section + 1).sender.senderId
	}

	func isLastSectionVisible() -> Bool {
		let messagesCount = self.presenter.getMessagesCount()
		guard messagesCount != 0 else { return false }
		let lastIndexPath = IndexPath(item: 0, section: messagesCount - 1)
		return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
	}
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate
{
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		inputBar.inputTextView.text = ""
		let message = Message(sender: self.currentSender(),
							  messageId: UUID().uuidString,
							  sentDate: Date(),
							  kind: .text(text))
		self.presenter.sendMessage(message: message)
	}
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource
{
	func currentSender() -> SenderType {
		guard let userData = self.presenter.getCurrentUserData() else {
			return MessageSender(senderId: "", displayName: "")
		}
		return MessageSender(senderId: "\(userData.userId)", displayName: userData.username)
	}

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return self.presenter.getMessage(at: indexPath.section)
	}

	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return self.presenter.getMessagesCount()
	}

	func cellTopLabelAttributedText(for message: MessageType,
									at indexPath: IndexPath) -> NSAttributedString? {
		if self.isTimeLabelVisible(at: indexPath) {
			return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
									  attributes: [
										NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
										NSAttributedString.Key.foregroundColor: UIColor.darkGray,
									  ])
		}
		return nil
	}

	func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		if self.isPreviousMessageSameSender(at: indexPath) == false {
			let name = message.sender.displayName
			return NSAttributedString(string: name,
									  attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
		}
		return nil
	}

	func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		let dateString = MessageKitDateFormatter.shared.string(from: message.sentDate)
		return NSAttributedString(string: dateString,
								  attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
	}
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate
{
	func textColor(for message: MessageType,
				   at indexPath: IndexPath,
				   in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return .darkText
	}

	func backgroundColor(for message: MessageType,
						 at indexPath: IndexPath,
						 in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return self.isFromCurrentSender(message: message) ? MainConstants.messageBackgroundColorFromCurrentUser :
			MainConstants.messageBackgroundColorFromOtherUsers
	}

	func configureAvatarView(_ avatarView: AvatarView,
							 for message: MessageType,
							 at indexPath: IndexPath,
							 in messagesCollectionView: MessagesCollectionView) {
		avatarView.backgroundColor = .clear
		avatarView.tintColor = MainConstants.profileImageViewTintColor
		avatarView.isHidden = self.isNextMessageSameSender(at: indexPath)
		if message.sender.senderId == self.currentSender().senderId {
			let avatar = Avatar(image: self.presenter.getCurrentUserImage(), initials: "")
			avatarView.set(avatar: avatar)
		}
		else {
			if let senderId = Int(message.sender.senderId) {
				let avatar = Avatar(image: self.presenter.getChatMemberImage(withSenderId: senderId), initials: "")
				avatarView.set(avatar: avatar)
			}
		}
	}
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate
{
	func cellTopLabelHeight(for message: MessageType,
							at indexPath: IndexPath,
							in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		if self.isTimeLabelVisible(at: indexPath) {
			return 18
		}
		return 0
	}

	func messageTopLabelHeight(for message: MessageType,
							   at indexPath: IndexPath,
							   in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return self.isPreviousMessageSameSender(at: indexPath) == false ? 20 : 0
	}

	func messageBottomLabelHeight(for message: MessageType,
								  at indexPath: IndexPath,
								  in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return 16
	}
}

// MARK: - IChatViewController
extension ChatViewController: IChatViewController
{
	func refreshChatRoomInfo() {
		DispatchQueue.main.async {
			self.setupTitle()
			self.setupImage()
		}
	}

	func loadFirstMessages() {
		DispatchQueue.main.async {
			self.activityIndicator.isHidden = true
			self.activityIndicator.stopAnimating()
			self.messagesCollectionView.reloadData()
			self.messagesCollectionView.scrollToBottom()
		}
	}

	func loadMoreMessages() {
		DispatchQueue.main.async {
			self.messagesCollectionView.reloadDataAndKeepOffset()
		}
	}

	func insertMessage() {
		self.messageInputBar.sendButton.startAnimating()
		let messagesCount = self.presenter.getMessagesCount()
		self.messagesCollectionView.performBatchUpdates({
			let index1 = messagesCount - 1
			self.messagesCollectionView.insertSections([index1])
			if messagesCount >= 2 {
				let index2 = messagesCount - 2
				messagesCollectionView.reloadSections([index2])
			}
		}, completion: { [weak self] _ in
			if self?.isLastSectionVisible() == true {
				self?.messagesCollectionView.scrollToBottom(animated: true)
				self?.messageInputBar.sendButton.stopAnimating()
			}
		})
	}
}
