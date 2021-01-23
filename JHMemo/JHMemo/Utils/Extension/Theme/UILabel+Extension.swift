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
		self.font = .boldSystemFont(ofSize: size)
		self.text = text
		self.adjustsFontSizeToFitWidth = true
	}
	
	func setBodyStyle(text: String?, size: CGFloat, color: UIColor) {
		self.textColor = color
		self.font = .systemFont(ofSize: size)
		self.text = text
		self.adjustsFontSizeToFitWidth = true
	}
}
