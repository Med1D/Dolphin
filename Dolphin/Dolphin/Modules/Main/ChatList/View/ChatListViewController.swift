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

// MARK: - UI properties
	private let tableView = UITableView()

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
		self.setupTableView()
	}

// MARK: - viewWillAppear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let indexPath = self.tableView.indexPathForSelectedRow {
			let selectedCell = self.tableView.cellForRow(at: indexPath) as? ChatRoomCell
			selectedCell?.setHighlighted(is: false)
		}
	}
}

// MARK: - Private methods (Setup UI)
private extension ChatListViewController
{
	func setupTableView() {
		self.view.addSubview(self.tableView)
		self.tableView.frame = self.view.bounds
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.separatorInset.left = MainConstants.imageLeadingOffset +
			MainConstants.imageSize + MainConstants.imageLeadingOffset
		self.tableView.tableFooterView = UIView()
		self.tableView.register(ChatRoomCell.self, forCellReuseIdentifier: ChatRoomCell.cellReuseIdentifier)
	}
}

// MARK: - Private methods
private extension ChatListViewController
{
}

// MARK: - UITableViewDataSource
extension ChatListViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: ChatRoomCell.cellReuseIdentifier) as? ChatRoomCell
		cell?.chatRoom = ChatRoom(image: nil, name: "ChatRoom №\(indexPath.row)",
								  lastMessage: "Hello, World! This beautiful message is so big. And what you think about this? Yeah, big.",
								  lastMessageTime: "20:1\(indexPath.row)")
		return cell ?? UITableViewCell(style: .default, reuseIdentifier: ChatRoomCell.cellReuseIdentifier)
	}
}

// MARK: - UITableViewDelegate
extension ChatListViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return MainConstants.imageBottomOffset + MainConstants.imageTopOffset + MainConstants.imageSize
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return MainConstants.imageBottomOffset + MainConstants.imageTopOffset + MainConstants.imageSize
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = self.tableView.cellForRow(at: indexPath) as? ChatRoomCell
		selectedCell?.setHighlighted(is: true)
	}

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? ChatRoomCell
		highlightedCell?.setHighlighted(is: true)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? ChatRoomCell
		highlightedCell?.setHighlighted(is: false)
	}
}

// MARK: - IChatListViewController
extension ChatListViewController: IChatListViewController
{
}
