//
//  UIImageView + Extension.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 10.08.2021.
//

import UIKit

extension UIImageView {

	convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
		self.init()
		self.image = image
		self.contentMode = contentMode
	}
}
