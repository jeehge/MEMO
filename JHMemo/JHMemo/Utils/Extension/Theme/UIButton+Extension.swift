//
//  UIButton+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import UIKit

extension UIButton {
	// 그림자 설정
	func setShadow() {
		self.layer.shadowColor = UIColor(named: ColorName.shadow.description)?.cgColor
		self.layer.shadowOffset = CGSize(width: 3, height: 3)
//        self.layer.shadowRadius = 3
		self.layer.shadowOpacity = 0.4
	}
	
	// 완료 버튼 설정
	func setCompleteStyle(size: CGFloat) {
		self.backgroundColor = UIColor(named: ColorName.button.description)
		self.tintColor =  .white
		self.layer.cornerRadius = 8
		self.titleLabel?.font = .systemFont(ofSize: size.adjused)
	}
	
	// 확인/수정 버튼 설정
	func setConfirmStyle(text: String, size: CGFloat, color: UIColor) {
		self.titleLabel?.font = .boldSystemFont(ofSize: size.adjused)
		self.setTitle(text, for: .normal)
		self.setTitleColor(color, for: .normal)
	}
	
	// 취소/지우기 버튼 설정
	func setCancelStyle(text: String, size: CGFloat, color: UIColor) {
		self.titleLabel?.font = .boldSystemFont(ofSize: size.adjused)
		self.setTitle(text, for: .normal)
		self.setTitleColor(color, for: .normal)
	}
}
