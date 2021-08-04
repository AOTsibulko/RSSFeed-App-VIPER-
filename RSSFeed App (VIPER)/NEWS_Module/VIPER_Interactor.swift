//
//  VIPER_Interactor.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit


protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    func getNews()
}

class NewsInteractor: NSObject, AnyInteractor {
   
    var presenter: AnyPresenter?
    
    private var rssItems: [RSSItem] = []
    private var currentElement: String = ""
    private var weAreInsideItem: Bool = false
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentUrlToImage: String = ""
    
    func getNews() {
        
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
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
} // end of class NewsInteractor

//MARK: - XMLParser Methods
extension NewsInteractor: XMLParserDelegate {
    
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
            let rssItem = RSSItem(title: currentTitle, pubDate: currentPubDate, urlToImage: currentUrlToImage)
            rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        presenter?.interactorDidFetchNews(with: .success(rssItems))
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        presenter?.interactorDidFetchNews(with: .failure(parseError))
    }
    
} // end of extension NewsInteractor: XMLParserDelegate
