//
//  ChatListViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 18.10.2020.
//

import UIKit

final class ChatListViewController: UIViewController
{
// MARK: - Properties
	private let presenter: IChatListPresenter

// MARK: - Init
	init(presenter: IChatListPresenter) {
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
		self.title = "Chat rooms"
		self.setupNavigationController()
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatListViewController
{
	func setupNavigationController() {
		self.navigationController?.tabBarItem = UITabBarItem(title: "Chat",
															 image: UIImage(systemName: "bubble.left.and.bubble.right"),
															 tag: 0)
	}
}

// MARK: - Private methods
private extension ChatListViewController
{
}

// MARK: - IChatListViewController
extension ChatListViewController: IChatListViewController
{
}
