//
//  NewsEntity.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit

struct RSSItemModel {

	/// Идентификатор новости
	var id: String = UUID().uuidString

	/// Заголовок новости
	var title: String

	/// Дата публикации новости
	var pubDate: Date

	/// Дата публикации новости в виде красивой строки для отображения пользователю
	var pubDateBeautifulString: String

	/// Ссылка на источник новости
	var linkToSource: String

	/// Ссылка на изображение новости
	var urlToImage: String

	/// Изображение для новости,
	var image: UIImage?

	/// Изображение для новости, используемое по умолчанию
	var defaultImage: UIImage? = UIImage(named: "rbk_logo.jpg")
}
