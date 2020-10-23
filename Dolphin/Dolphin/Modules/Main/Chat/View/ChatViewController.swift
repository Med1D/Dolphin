//
//  ChatViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 24.10.2020.
//

import UIKit
import MessageKit

final class ChatViewController: MessagesViewController
{
// MARK: - Properties
	private let presenter: IChatPresenter

// MARK: - UI properties

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
		self.view.backgroundColor = .systemGroupedBackground
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatViewController
{
}

// MARK: - Private methods
private extension ChatViewController
{
}

// MARK: - IChatViewController
extension ChatViewController: IChatViewController
{
}
