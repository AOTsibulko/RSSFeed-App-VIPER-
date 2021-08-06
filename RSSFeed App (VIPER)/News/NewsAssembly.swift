//
//  NewsAssembly.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 05.08.2021.
//

import UIKit

/// Протокол Assembly модуля News
protocol NewsAssemblyProtocol {

	/// Создать модуль News
	func makeNewsModule() -> UIViewController?
}

/// Assembly модуля News
final class NewsAssembly: NewsAssemblyProtocol {

	// MARK: - Protocol Conformance NewsAssemblyProtocol

	func makeNewsModule() -> UIViewController? {

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let view = storyboard.instantiateViewController(identifier: "NewsViewController") as? NewsViewController else {
			return nil
		}
		let interactor = NewsInteractor()
		let router = NewsRouter()
		let presenter = NewsPresenter(with: view, interactor: interactor, router: router)
		interactor.presenter = presenter
		router.viewController = view
		view.presenter = presenter

		return view
	}
}
