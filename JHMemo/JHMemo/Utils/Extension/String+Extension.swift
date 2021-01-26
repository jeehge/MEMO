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
}
