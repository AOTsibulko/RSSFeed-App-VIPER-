//
//  NewsInteractor.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit

/// Протокол интерактора модуля News
protocol NewsInteractorProtocol {

	/// Получить новости
	func fetchNews()

	/// Загрузить изображение для новости
	/// - Parameter rssItem: новость, для которой нужно загрузить изображение
	func downloadImageFor(rssItem: RSSItemModel)
}

/// Протокол общения интерактора  модуля News с презентером модуля News
protocol NewsInteractorOutputProtocol: AnyObject {

	/// Метод сообщает презентеру были ли получены новости или же получена ошибка
	///
	/// - Parameter result: блок с результами
	func didFetchNews(_ result: Result<[RSSItemModel], Error>)

	/// Метод передает презентеру новость с загруженным изображением
	///
	/// - Parameter rssItem: новость с загруженным изображением
	func didFetchImageForCell(_ rssItem: RSSItemModel)
}

/// Интерактор модуля News
final class NewsInteractor: NSObject {

	/// Презентер модуля News
	weak var presenter: NewsInteractorOutputProtocol?

	private let networkService: NetworkServiceProtocol

	/// Инициализатор интерактора
	/// - Parameter networkService: сервис, получающий данные из сети Интернет
	init(networkService: NetworkServiceProtocol) {
		self.networkService = networkService
	}
}

// MARK: - Protocol Confirmation NewsInteractorProtocol

extension NewsInteractor: NewsInteractorProtocol {

	func fetchNews() {

		let url = "http://static.feed.rbc.ru/rbc/logical/footer/news.rss"

		networkService.getData(from: url) { [weak self] (result) in
			guard let strongSelf = self else { return }
			switch result {
			case .success(let data):
				let parserService = XMLParserService()
				parserService.parseXML(data: data) { [weak self] (result) in
					guard let strongSelf = self else { return }
					switch result {
					case .success(let rssItems):
						strongSelf.presenter?.didFetchNews(.success(rssItems))
					case .failure(let error):
						strongSelf.presenter?.didFetchNews(.failure(error))
					}
				}
			case .failure(let error):
				strongSelf.presenter?.didFetchNews(.failure(error))
			}
		}
	}

	func downloadImageFor(rssItem: RSSItemModel) {

		networkService.getData(from: rssItem.urlToImage) { [weak self] result in
			guard let strongSelf = self else { return }
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					return
				}
				var newRssItem = rssItem
				newRssItem.image = image
				strongSelf.presenter?.didFetchImageForCell(newRssItem)
			case .failure:
				break
			}
		}
	}
}

