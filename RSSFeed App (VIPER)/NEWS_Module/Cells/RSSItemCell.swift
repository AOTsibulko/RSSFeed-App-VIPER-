//
//  RSSItemCell.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 04.08.2021.
//

import UIKit

class RSSItemCell: UITableViewCell {

    @IBOutlet weak var rssItemImageView: UIImageView!
    @IBOutlet weak var rssItemTitleLabel: UILabel!
    @IBOutlet weak var rssItemDateLabel: UILabel!
    
    var rssItemToDisplay: RSSItem?
 
    func configureCell(with rssItem: RSSItem) {
        
        rssItemImageView.image = nil
        rssItemTitleLabel.text = ""
        rssItemDateLabel.text = ""
        
        rssItemToDisplay = rssItem
        
        rssItemTitleLabel.text = rssItem.title
        
        rssItemDateLabel.text = editPubDateToDisplay(pubDate: rssItem.pubDate)
        
        guard let url = URL(string: rssItem.urlToImage) else {
            rssItemImageView.image = UIImage(named: "rbk_logo.jpg")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            if self?.rssItemToDisplay?.urlToImage == url.absoluteString {
                DispatchQueue.main.async {
                    self?.rssItemImageView.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
    
    private func editPubDateToDisplay(pubDate: String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        guard let date = df.date(from: pubDate) else { return "" }
        df.dateFormat = "MM-dd-yyyy HH:mm"
        df.locale = Locale(identifier: "ru_RU")
        return df.string(from: date)
    }
    
} // end of class RSSItemCell
