//
//  NewsDetailsRouter.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 10.08.2021.
//

import UIKit

/// Протокол роутера модуля  NewsDetails
protocol NewsDetailsRouterProtocol {

	/// Метод, принимающий от презентера команду идти обратно к модулю News
	func goBackToNewsModule()

	/// Метод, принимающий от презентера команду открыть источник новости в Safari
	/// - Parameter url: Ссылка на источник новости
	func goToSourceOfNews(url: URL)
}

/// Роутер модуля NewsDetails
final class NewsDetailsRouter {

	weak var viewController: UIViewController?
}

// MARK: - Protocol Confirmation NewsDetailsRouterProtocol

extension NewsDetailsRouter: NewsDetailsRouterProtocol {

	func goBackToNewsModule() {
		viewController?.navigationController?.popViewController(animated: true)
	}

	func goToSourceOfNews(url: URL) {
		UIApplication.shared.open(url)
	}
}
