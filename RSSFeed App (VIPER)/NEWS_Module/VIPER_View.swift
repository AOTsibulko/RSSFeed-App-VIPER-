//
//  VIPER_View.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit


protocol AnyView {
    var presenter: AnyPresenter? { get set }
    func update(with rssItems: [RSSItem])
    func update(with error: String)
}

class NewsViewController: UIViewController, AnyView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: AnyPresenter?
    
    var rssItems: [RSSItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - AnyView Methods
    func update(with rssItems: [RSSItem]) {
        DispatchQueue.main.async {
            self.rssItems = rssItems
            self.tableView.reloadData()
        }
    }
    
    func update(with error: String) {
            // TODO: - Displaying error message
    }
    
} // end of class NewsViewController


// MARK: - Table View Methods

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSItemCell", for: indexPath) as! RSSItemCell
        cell.configureCell(with: rssItems[indexPath.row])
        return cell
    }
}
