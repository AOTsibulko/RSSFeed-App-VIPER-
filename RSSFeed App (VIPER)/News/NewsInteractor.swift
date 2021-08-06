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
}

/// Протокол общения интерактора  модуля News с презентером модуля News
protocol NewsInteractorOutputProtocol: AnyObject {

	/// Метод сообщает презентеру были ли получены новости или же получена ошибка
	///
	/// - Parameter result: блок с результами
	func didFetchNews(_ result: Result<[RSSItemModel], Error>)
}

/// Интерактор модуля News
final class NewsInteractor: NSObject {

	/// Презентер модуля News
	weak var presenter: NewsInteractorOutputProtocol?
}

// MARK: - Protocol Confirmation NewsInteractorProtocol

extension NewsInteractor: NewsInteractorProtocol {

	func fetchNews() {
		let urlString = "http://static.feed.rbc.ru/rbc/logical/footer/news.rss"
		guard let url = URL(string: urlString) else {
			return
		}
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data else {
				if let error = error {
					print(error.localizedDescription)
				}
				return
			}

			let parser = XMLParserService()
			parser.interactor = self
			parser.parseXML(data: data)
		}
		task.resume()
	}
}

// MARK: - Protocol Confirmation XMLParserServiceOutputProtocol

extension NewsInteractor: XMLParserServiceOutputProtocol {

	func didParseData(_ result: Result<[RSSItemModel], Error>) {
		switch result {
		case .success(let rssItems):
			presenter?.didFetchNews(.success(rssItems))
		case .failure(let error):
			presenter?.didFetchNews(.failure(error))
		}
	}
}
