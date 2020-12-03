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
		self.setupNavigationController()
		self.setupTitleView()
		self.setupChatImageButton()
		self.configureMessageInputBar()
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
		let numberOfMembers = "5 members"
		let attributedText = NSMutableAttributedString(string: title + "\n" + numberOfMembers)
		attributedText.addAttribute(.foregroundColor,
									value: UIColor.black,
									range: NSRange(location: 0, length: title.count))
		attributedText.addAttribute(.font,
									value: MainConstants.helveticaNeueMedium16 ?? UIFont.systemFont(ofSize: 16),
									range: NSRange(location: 0, length: title.count))
		attributedText.addAttribute(.foregroundColor,
									value: UIColor.lightGray,
									range: NSRange(location: title.count + 1, length: numberOfMembers.count))
		attributedText.addAttribute(.font,
									value: MainConstants.helveticaNeueLight14 ?? UIFont.systemFont(ofSize: 14),
									range: NSRange(location: title.count + 1, length: numberOfMembers.count))
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
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate
{
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		inputBar.inputTextView.text = ""
		print(text)
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
}
