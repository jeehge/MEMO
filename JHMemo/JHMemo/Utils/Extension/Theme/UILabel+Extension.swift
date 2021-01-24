//
//  UILabel+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import UIKit

extension UILabel {
	func setTitleStyle(text: String?, size: CGFloat) {
		self.textColor = UIColor(named: ColorName.title.description)
		self.font = .boldSystemFont(ofSize: size.adjused)
		self.text = text
		self.adjustsFontSizeToFitWidth = true
	}
	
	func setBodyStyle(text: String?, size: CGFloat) {
		self.textColor = UIColor(named: ColorName.text.description)
		self.font = .systemFont(ofSize: size.adjused)
		self.text = text
		self.adjustsFontSizeToFitWidth = true
	}
}

