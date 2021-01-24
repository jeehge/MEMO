//
//  UIView+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/24.
//

import UIKit

extension UIView {
	// 모서리가 둥근 뷰
	func setRoundViewStyle(color: UIColor, cornerRadius: CGFloat) {
		self.backgroundColor = color
		self.layer.cornerRadius = cornerRadius
	}
}
