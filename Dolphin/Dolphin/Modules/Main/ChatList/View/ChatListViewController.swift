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
	private let tableView = UITableView(frame: .zero, style: .grouped)
	private let searchController = UISearchController(searchResultsController: nil)

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
		self.setupTableView()
		self.setupSearchController()
		self.presenter.getChatRooms()
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
	func setupNavigationController() {
		navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "",
																						 style: .plain,
																						 target: nil,
																						 action: nil)
	}

	func setupTableView() {
		self.view.addSubview(self.tableView)
		self.tableView.frame = self.view.bounds
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.separatorInset.left = MainConstants.imageLeadingOffset +
			MainConstants.imageSize + MainConstants.imageLeadingOffset
		self.tableView.backgroundColor = .white
		self.tableView.register(ChatRoomCell.self, forCellReuseIdentifier: ChatRoomCell.cellReuseIdentifier)
	}

	func setupSearchController() {
		self.searchController.searchResultsUpdater = self
		self.searchController.obscuresBackgroundDuringPresentation = false
		self.searchController.searchBar.placeholder = MainConstants.searchBarPlaceholder
		self.navigationItem.searchController = self.searchController
		self.definesPresentationContext = true
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
		return self.presenter.getChatRoomsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: ChatRoomCell.cellReuseIdentifier) as? ChatRoomCell
		cell?.chatRoom = self.presenter.getChatRoom(at: indexPath.row)
		return cell ?? UITableViewCell(style: .default, reuseIdentifier: ChatRoomCell.cellReuseIdentifier)
	}
}

// MARK: - UITableViewDelegate
extension ChatListViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return .leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return MainConstants.imageBottomOffset + MainConstants.imageTopOffset + MainConstants.imageSize
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return MainConstants.imageBottomOffset + MainConstants.imageTopOffset + MainConstants.imageSize
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = self.tableView.cellForRow(at: indexPath) as? ChatRoomCell
		selectedCell?.setHighlighted(is: true)
		guard let chatRoomData = selectedCell?.chatRoom?.chatRoomData else { return }
		self.presenter.selectChatRoom(chatRoomData: chatRoomData) { viewController in
			self.navigationController?.pushViewController(viewController, animated: true)
		}
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

// MARK: - UISearchResultsUpdating
extension ChatListViewController: UISearchResultsUpdating
{
	func updateSearchResults(for searchController: UISearchController) {
	}
}

// MARK: - IChatListViewController
extension ChatListViewController: IChatListViewController
{
	func reloadChatRoomsList() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}
