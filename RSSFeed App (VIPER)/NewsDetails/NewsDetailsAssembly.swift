//
//  NewsDetailsAssembly.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 10.08.2021.
//

import UIKit

/// Протокол Assembly модуля NewsDetails
protocol NewsDetailsAssemblyProtocol {

	/// Создать модуль NewsDetails
	/// - Parameter rssItem: новость, которую нужно будет отобразить на экране модуля NewsDetails
	func makeNewsDetailsModule(with rssItem: RSSItemModel) -> UIViewController?
}

/// Assembly модуля NewsDetails
final class NewsDetailsAssembly: NewsDetailsAssemblyProtocol {

	func makeNewsDetailsModule(with rssItem: RSSItemModel) -> UIViewController? {
		let view = NewsDetailsViewController()
		let router = NewsDetailsRouter()
		let presenter = NewsDetailsPresenter(with: view, router: router)

		view.presenter = presenter
		presenter.rssItem = rssItem
		router.viewController = view
		
		return view
	}
}
