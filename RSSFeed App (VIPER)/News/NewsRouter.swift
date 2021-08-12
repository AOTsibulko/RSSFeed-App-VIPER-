//
//  NewsRouter.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit

/// Протокол роутера модуля News
protocol NewsRouterProtocol {

	/// Показать сообщение об ошибке
	/// - Parameter alert: контроллер, показывающий сообщение
	func showError(alert: UIAlertController)

	/// Перейти к модулю NewsDetails
	/// - Parameter rssItem: новость, которая передается в модуль NewsDetails
	func goToNewsDetails(with rssItem: RSSItemModel)
}

/// Роутер модуля News
final class NewsRouter {

	weak var viewController: UIViewController?
}

// MARK: - Protocol Confirmation NewsRouterProtocol

extension NewsRouter: NewsRouterProtocol {

	func showError(alert: UIAlertController) {
		DispatchQueue.main.async {
			self.viewController?.present(alert, animated: true, completion: nil)
		}
	}

	func goToNewsDetails(with rssItem: RSSItemModel) {
		guard let newsDetailsVC = NewsDetailsAssembly().makeNewsDetailsModule(with: rssItem) else { return }
		viewController?.navigationController?.pushViewController(newsDetailsVC, animated: true)
	}
}
