//
//  XMLParserService.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 05.08.2021.
//

import Foundation

/// Протокол общения XMLParserService и интерактора модуля News
protocol XMLParserServiceOutputProtocol: AnyObject {

	/// Сообщить интерактору результат парсинга в виде данных в формате массива RSSItemModel или сообщить об ошибке
	func didParseData(_ result: Result<[RSSItemModel], Error>)
}

/// Сервис осуществляет парсинг данных в формате XML
final class XMLParserService: NSObject {

	/// Интерактор модуля News
	weak var interactor: XMLParserServiceOutputProtocol?

	/// Метод осуществляет парсинг данных в формате XML
	func parseXML(data: Data) {
		let parser = XMLParser(data: data)
		parser.delegate = self
		parser.parse()
	}

	// MARK: - Private

	private var rssItems: [RSSItemModel] = []
	private var currentElement: String = ""
	private var weAreInsideItem: Bool = false
	private var currentTitle: String = "" {
		didSet {
			currentTitle = deleteWhiteSpacesAndNewLines(from: currentTitle)
		}
	}
	private var currentPubDate: String = "" {
		didSet {
			currentPubDate = deleteWhiteSpacesAndNewLines(from: currentPubDate)
		}
	}
	private var currentUrlToImage: String = ""

	private func deleteWhiteSpacesAndNewLines(from string: String) -> String {
		return string.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	private func convertStringToDate(_ pubDate: String) -> Date? {
		let df = DateFormatter()
		df.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
		guard let date = df.date(from: pubDate) else { return nil }
		return date
	}
}

// MARK: - Protocol Confirmation XMLParserDelegate

extension XMLParserService: XMLParserDelegate {

	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

		currentElement = elementName

		if currentElement == "item" {
			currentTitle = ""
			currentPubDate = ""
			currentUrlToImage = ""
			weAreInsideItem = true
		}

		if currentElement == "enclosure" {
			if weAreInsideItem == true {
				if attributeDict["type"] != nil && attributeDict["type"] == "image/jpeg" {
					guard let urlToImage = attributeDict["url"] else { return }
					currentUrlToImage = urlToImage
				}
			}
			weAreInsideItem = false
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {

		switch currentElement {
			case "title": currentTitle += string
			case "pubDate": currentPubDate += string
			default: break
		}
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

		if elementName == "item" {
			guard let currentPubDate = convertStringToDate(currentPubDate) else { return }
			let rssItem = RSSItemModel(title: currentTitle, pubDate: currentPubDate, urlToImage: currentUrlToImage)
			rssItems.append(rssItem)
		}
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		interactor?.didParseData(.success(rssItems))
	}

	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		interactor?.didParseData(.failure(parseError))
	}
}
