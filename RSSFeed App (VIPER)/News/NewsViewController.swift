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

	/// Обновить  ячейку с помощью параметра
	///
	/// - Parameter rssItem: новость в формате RSSItemModel
	func updateCell(with rssItem: RSSItemModel)
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
		tableView?.delegate = self
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

		if rssItems[indexPath.row].image == nil {
			presenter?.viewNeedsImageForCellWith(rssItem: rssItems[indexPath.row])
		}

		cell.configureCell(with: rssItems[indexPath.row])
		return cell
	}
}

// MARK: - Protocol Conformance UITableViewDelegate

extension NewsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.didTapNewsCell(with: rssItems[indexPath.row])
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

	func updateCell(with rssItem: RSSItemModel) {
		DispatchQueue.main.async {
			guard let index = self.rssItems.firstIndex(where: { $0.id == rssItem.id }) else { return }
			self.rssItems[index] = rssItem
			let indexPath = IndexPath(item: index, section: 0)
			guard self.tableView?.indexPathsForVisibleRows?.contains(indexPath) == true else { return }
			guard let cell = self.tableView?.cellForRow(at: indexPath) as? RSSItemCell else { return }
			cell.configureCell(with: rssItem)
		}
	}
}
