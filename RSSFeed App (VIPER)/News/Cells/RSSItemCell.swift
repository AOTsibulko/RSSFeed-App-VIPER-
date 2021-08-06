//
//  RSSItemCell.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 04.08.2021.
//

import UIKit

/// Ячейка таблицы с новостями на экране News
final class RSSItemCell: UITableViewCell {

	/// ImageView с изображение новости в ячейке
	@IBOutlet weak var rssItemImageView: UIImageView?

	/// Лейбл с заголовком новости в ячейке
	@IBOutlet weak var rssItemTitleLabel: UILabel?

	/// Лейбл с датой публикации новости в ячейке
	@IBOutlet weak var rssItemDateLabel: UILabel?

	/// Новость для отображения в текущей ячейке
	var rssItemToDisplay: RSSItemModel?

	/// Отобразить в ячейке информацию с использованием данных параметра
	///
	/// - Parameter rssItem: новость, которую необходимо отобразить в ячейке
	func configureCell(with rssItem: RSSItemModel) {

		rssItemToDisplay = rssItem
		rssItemTitleLabel?.text = rssItem.title
		rssItemDateLabel?.text = rssItem.getPubDateInStringFormat()

		if rssItem.image != nil {
			rssItemImageView?.image = rssItem.image
			return
		}

		rssItemImageView?.image = rssItem.defaultImage

		rssItem.getImage { [weak self, rssItem] image in
			guard let strongSelf = self,
				  image != nil,
				  strongSelf.rssItemToDisplay === rssItem
			else { return }

			strongSelf.rssItemImageView?.image = image
		}
	}
}
