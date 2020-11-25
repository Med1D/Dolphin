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
	private let chatRoomData: ChatRoomData

// MARK: - UI properties
	private let chatImageButtonView = UIView()
	private let chatTitleView = UIView()

// MARK: - Init
	init(presenter: IChatPresenter, chatRoomData: ChatRoomData) {
		self.presenter = presenter
		self.chatRoomData = chatRoomData
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

// MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTitleView()
		self.setupChatImageButton()
		self.configureMessageInputBar()
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatViewController
{
	func setupTitleView() {
		let title = self.chatRoomData.title
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
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 44))
		label.numberOfLines = 2
		label.attributedText = attributedText
		label.center = self.chatTitleView.center
		label.textAlignment = .center
		self.chatTitleView.addSubview(label)
		self.navigationItem.titleView = self.chatTitleView
	}

	func setupChatImageButton() {
		let image = UIImage.decodeImageFromBase64String(string: self.chatRoomData.encodedImage)
		let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		self.chatImageButtonView.frame = frame
		let imageView = UIImageView(frame: frame)
		imageView.image = image
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = frame.height / 2
		imageView.clipsToBounds = true
		self.chatImageButtonView.addSubview(imageView)
		let button = UIButton(frame: frame)
		button.addTarget(self, action: #selector(self.dragChatImageButton), for: [.touchDragInside, .touchDragOutside])
		button.addTarget(self, action: #selector(self.touchCancelChatImageButton), for: .touchCancel)
		button.addTarget(self, action: #selector(self.touchUpChatImageButton), for: [.touchUpInside, .touchUpOutside])
		button.backgroundColor = .clear
		button.setTitle("", for: .normal)
		self.chatImageButtonView.addSubview(button)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.chatImageButtonView)
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
	func animateImageButton(closure: @escaping () -> Void) {
		UIView.animate(withDuration: 0.25,
					   delay: 0,
					   options: .curveEaseInOut,
					   animations: closure,
					   completion: nil)
	}

	@objc func dragChatImageButton() {
		if self.chatImageButtonView.alpha == 1 {
			self.animateImageButton {
				[weak self] in self?.chatImageButtonView.alpha = 0.5
			}
		}
	}

	@objc func touchCancelChatImageButton() {
		self.animateImageButton {
			[weak self] in self?.chatImageButtonView.alpha = 1
		}
	}

	@objc func touchUpChatImageButton() {
		if self.chatImageButtonView.alpha == 1 {
			self.animateImageButton {
				[weak self] in self?.chatImageButtonView.alpha = 0.5
			}
		}
		self.animateImageButton {
			[weak self] in self?.chatImageButtonView.alpha = 1
		}
		print("Open chat room info")
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
}
