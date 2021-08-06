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
	func showError(alert: UIAlertController)
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
}
