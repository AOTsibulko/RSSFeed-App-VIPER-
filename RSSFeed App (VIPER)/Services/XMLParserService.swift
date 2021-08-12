//
//  XMLParserService.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 05.08.2021.
//

import Foundation

/// Сервис осуществляет парсинг данных в формате XML
final class XMLParserService: NSObject {

	func parseXML(data: Data, completionHandler: ((Result<[RSSItemModel], Error>) -> Void)?) {
		self.parserCompletionHandler = completionHandler
		let parser = XMLParser(data: data)
		parser.delegate = self
		parser.parse()
	}

	// MARK: - Private
	private enum ElementType: String {
		case item
		case enclosure

		init?(rawValue: String) {
			switch rawValue {
			case "item": self = .item
			case "enclosure": self = .enclosure
			default: return nil
			}
		}
	}

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
	private var currentLinkToSource: String = "" {
		didSet {
			currentLinkToSource = deleteWhiteSpacesAndNewLines(from: currentLinkToSource)
		}
	}
	private var parserCompletionHandler: ((Result<[RSSItemModel], Error>) -> Void)?

	private func deleteWhiteSpacesAndNewLines(from string: String) -> String {
		return string.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	private func convertStringToDate(_ pubDate: String) -> Date? {
		let df = DateFormatter()
		df.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
		guard let date = df.date(from: pubDate) else { return nil }
		return date
	}

	private func changePubDateToBeautifulString(_ pubDate: Date) -> String {
		let df = DateFormatter()
		df.dateFormat = "MM-dd-yyyy HH:mm"
		df.locale = Locale(identifier: "ru_RU")
		return df.string(from: pubDate)
	}
}

// MARK: - Protocol Confirmation XMLParserDelegate

extension XMLParserService: XMLParserDelegate {

	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

		currentElement = elementName

		guard let elementType = ElementType(rawValue: currentElement) else { return }

		switch elementType {
		case .item:
			currentTitle = ""
			currentPubDate = ""
			currentUrlToImage = ""
			currentLinkToSource = ""
			weAreInsideItem = true
		case .enclosure:
			guard weAreInsideItem,
				  attributeDict["type"] != nil,
				  attributeDict["type"] == "image/jpeg",
				  let urlToImage = attributeDict["url"]
			else { return }
			currentUrlToImage = urlToImage
			weAreInsideItem = false
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {

		switch currentElement {
		case "title": currentTitle += string
		case "link": currentLinkToSource += string
		case "pubDate": currentPubDate += string
		default: break
		}
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

		if elementName == "item" {
			guard let currentPubDate = convertStringToDate(currentPubDate) else { return }
			let pubDateBeautifulString = changePubDateToBeautifulString(currentPubDate)

			let rssItem = RSSItemModel(title: currentTitle,
									   pubDate: currentPubDate,
									   pubDateBeautifulString: pubDateBeautifulString,
									   linkToSource: currentLinkToSource,
									   urlToImage: currentUrlToImage)
			rssItems.append(rssItem)
		}
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		parserCompletionHandler?(.success(rssItems))
	}

	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		parserCompletionHandler?(.failure(parseError))
	}
}
