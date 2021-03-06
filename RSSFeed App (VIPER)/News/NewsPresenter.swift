//
//  NewsPresenter.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit

/// Протокол презентера модуля News
protocol NewsPresenterProtocol: AnyObject {

	/// Метод информирует презентер о том, что экран модуля News загрузился
	func viewDidLoad()

	/// Метод информирует презентер о том, что пользователь нажал на новость на экране модуля News
	/// - Parameter rssItem: новость на которую нажал пользователь
	func didTapNewsCell(with rssItem: RSSItemModel)

	/// Метод информирует презентер о том, что нужно загрузить изображение для ячейки таблицы на экране модуля News
	/// - Parameter rssItem: новость, для которой нужно загрузить изображение
	func viewNeedsImageForCellWith(rssItem: RSSItemModel)
}

/// Презентер модуля News
final class NewsPresenter {

	private weak var view: NewsViewProtocol?
	private var interactor: NewsInteractorProtocol
	private var router: NewsRouterProtocol

	/// Инициализатор класса
	///
	/// - Parameters:
	///   - view: экран модуля News
	///   - interactor: интерактор модуля News
	///   - router: роутер  модуля News
	init(with view: NewsViewProtocol,
		 interactor: NewsInteractorProtocol,
		 router: NewsRouterProtocol
	) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}

	private func showErrorAlert() {
		let errorAlertController = UIAlertController(title: "УПС!",
												message: "Что-то пошло не так. Обратитесь к разработчику!",
												preferredStyle: .alert)
		errorAlertController.addAction(UIAlertAction(title: "Ок",
												style: .default,
												handler: nil))
		router.showError(alert: errorAlertController)
	}
}

//MARK: - Protocol Confirmation NewsPresenterProtocol

extension NewsPresenter: NewsPresenterProtocol {

	func viewDidLoad() {
		interactor.fetchNews()
	}

	func didTapNewsCell(with rssItem: RSSItemModel) {
		router.goToNewsDetails(with: rssItem)
	}

	func viewNeedsImageForCellWith(rssItem: RSSItemModel) {
		interactor.downloadImageFor(rssItem: rssItem)
	}
}

//MARK: - Protocol Confirmation NewsInteractorOutputProtocol

extension NewsPresenter: NewsInteractorOutputProtocol {

	func didFetchNews(_ result: Result<[RSSItemModel], Error>) {
		switch result {
		case .success(let rssItems):
			view?.update(with: rssItems)
		case .failure(_):
			showErrorAlert()
		}
	}

	func didFetchImageForCell(_ result: RSSItemModel) {
		view?.updateCell(with: result)
	}
}
