//
//  NewsDetailsPresenter.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 10.08.2021.
//

import Foundation

/// Протокол презентера модуля NewsDetails
protocol NewsDetailsPresenterProtocol {

	/// Метод информирует презентер о том, что экран модуля NewsDetails загрузился
	func viewDidLoad()

	/// Метод информирует презентер о том, пользователь нажал кнопку "Назад"
	func backButtonTapped()

	/// Метод информирует презентер о том, пользователь нажал кнопку "Перейти к источнику"
	/// - Parameter url: Ссылка на источник новости
	func goToSourceButtonTapped(url: URL)
}

/// Презентер модуля NewsDetails
final class NewsDetailsPresenter {

	/// Новость для отображения на экране
	var rssItem: RSSItemModel?

	private weak var view: NewsDetailsViewProtocol?
	private var router: NewsDetailsRouterProtocol

	/// Инициализатор класса
	///
	/// - Parameters:
	///   - view: экран модуля News
	///   - router: роутер  модуля News
	init(with view: NewsDetailsViewProtocol,
		 router: NewsDetailsRouterProtocol
	) {
		self.view = view
		self.router = router
	}
}

// MARK: - Protocol Confirmation NewsDetailsPresenterProtocol

extension NewsDetailsPresenter: NewsDetailsPresenterProtocol {

	func viewDidLoad() {
		guard let rssItem = rssItem else { return }
		view?.update(with: rssItem)
	}

	func backButtonTapped() {
		router.goBackToNewsModule()
	}

	func goToSourceButtonTapped(url: URL) {
		router.goToSourceOfNews(url: url)
	}
}
