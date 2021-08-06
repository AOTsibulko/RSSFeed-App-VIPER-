//
//  NewsEntity.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit

/// View Model для одной новости на экране модуля News
final class RSSItemModel {

	/// Заголовок новости
	var title: String

	/// Дата публикации новости
	var pubDate: Date

	private var urlToImage: String

	/// Изображение для новости,
	var image: UIImage?

	/// Изображение для новости, используемое по умолчанию
	lazy var defaultImage: UIImage? = UIImage(named: "rbk_logo.jpg")

	/// Инициализатор класса
	///
	/// - Parameters:
	///   - title: Заголовок новости
	///   - pubDate: Дата публикации новости
	///   - urlToImage: Ссылка на изображение для новости
	init(title: String, pubDate: Date, urlToImage: String) {
		self.title = title
		self.pubDate = pubDate
		self.urlToImage = urlToImage
	}

	/// Метод присваивает изображение для новости
	func getImage(_ completion: @escaping (UIImage?) -> Void) {

		guard image == nil else {
			completion(image)
			return
		}
		guard let url = URL(string: urlToImage) else {
			completion(self.defaultImage)
			return
		}
		let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
			guard let strongSelf = self, let data = data, error == nil, let image = UIImage(data: data) else {
				DispatchQueue.main.async {
					completion(self?.defaultImage)
				}
				return
			}
			DispatchQueue.main.async {
				strongSelf.image = image
				completion(image)
			}
		}
		task.resume()
	}

	/// Метод возвращает дату публикации новости в формате строки
	func getPubDateInStringFormat() -> String {
		let df = DateFormatter()
		df.dateFormat = "MM-dd-yyyy HH:mm"
		df.locale = Locale(identifier: "ru_RU")
		return df.string(from: pubDate)
	}
}
