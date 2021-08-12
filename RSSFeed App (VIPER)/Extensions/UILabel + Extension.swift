//
//  UILabel + Extension.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 10.08.2021.
//

import UIKit

extension UILabel {

	convenience init(text: String, font: UIFont, numberOfLines: Int) {
		self.init()
		self.text = text
		self.font = font
		self.numberOfLines = numberOfLines
	}
}
