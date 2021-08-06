//
//  NewsViewController.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit

/// Протокол экрана модуля News
protocol NewsViewProtocol: AnyObject {

	/// Обновить  экран с помощью параметра
	///
	/// - Parameter rssItems: массив, содержащий новости в формате моделей RSSItemModel
	func update(with rssItems: [RSSItemModel])
}

/// Экран модуля News
final class NewsViewController: UIViewController {

	/// Таблица для отображения на экране модуля News
	@IBOutlet weak var tableView: UITableView?

	/// Презентер модуля News
	var presenter: NewsPresenterProtocol?

	/// Новости для отображения в таблице
	var rssItems: [RSSItemModel] = []

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView?.dataSource = self
		presenter?.viewDidLoad()
	}
}

// MARK: - Protocol Conformance UITableViewDataSource

extension NewsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rssItems.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "RSSItemCell",
													   for: indexPath) as? RSSItemCell
		else { return UITableViewCell() }
		cell.configureCell(with: rssItems[indexPath.row])
		return cell
	}
}

// MARK: - Protocol Conformance NewsViewProtocol

extension NewsViewController: NewsViewProtocol {

	func update(with rssItems: [RSSItemModel]) {
		DispatchQueue.main.async {
			self.rssItems = rssItems
			self.tableView?.reloadData()
		}
	}
}
