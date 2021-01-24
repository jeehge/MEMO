//
//  UITextView+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/24.
//

import UIKit

extension UITextView {
	func setHashTagTextViewStyle(size: CGFloat) {
		self.textColor = UIColor(named: ColorName.text.description)
		self.font = .systemFont(ofSize: size)
	}
}
