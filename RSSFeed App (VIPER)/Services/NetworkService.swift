//
//  NetworkService.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 12.08.2021.
//

import Foundation

/// Протокол сервиса, получающий данные из сети Интернет
protocol NetworkServiceProtocol {

	/// Получить данные по ссылке
	///
	/// - Parameters:
	///   - url: ссылка
	///   - completion: блок с результатами
	func getData(from url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

/// Сервис, получающий данные из сети Интернет
final class NetworkService: NetworkServiceProtocol {

	// MARK: - Protocol Confirmation NetworkServiceProtocol

	func getData(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {

		guard let url = URL(string: url) else {
			return
		}
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data else {
				if let error = error {
					completion(.failure(error))
				}
				return
			}
			completion(.success(data))
		}
		task.resume()
	}
}
