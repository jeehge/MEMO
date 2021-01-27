//
//  String+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import Foundation

extension String {
	// 다국어화
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}

	// 글자 치환
	func replace(_ target: String, _ withString: String) -> String {
		return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
	}

	// 내가 원하는 포맷에 맞게 Date로 돌려준다. (기본 yyyy.MM.dd)
	func getStringDate(format: String = "yyyy.MM.dd") -> Date? {
		let formater = DateFormatter()
		formater.dateFormat = format
		return formater.date(from: self)
	}

	func getChangeDateFormat(beforeFormat: String = "YYYYMMdd", afterFormat: String = "yyyy. MM. dd.") -> String {
		let formmater = DateFormatter()
		formmater.dateFormat = beforeFormat
		let date = formmater.date(from: self)
		formmater.dateFormat = afterFormat
		let formattedString = formmater.string(from: date!)
		return formattedString
	}

	func getChangeTimeFormat(beforeFormat: String = "HHmmss", afterFormat: String = "HH:mm:ss") -> String {
		let formmater = DateFormatter()
		formmater.dateFormat = beforeFormat
		let date = formmater.date(from: self)
		formmater.dateFormat = afterFormat
		let formattedString = formmater.string(from: date!)
		return formattedString
	}
}
