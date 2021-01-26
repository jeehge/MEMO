//
//  Date+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/24.
//

import UIKit

extension Date {
	// 내가 원하는 포맷에 맞게 String으로 돌려준다. (기본 yyyy.MM.dd)
	func getDateString(format: String = "yyyy.MM.dd") -> String {
		let formater = DateFormatter()
		formater.dateFormat = format
		return formater.string(from: self)
	}

	// n일 뒤 날자를 돌려준다 (선택한 날짜의 7일 뒤 할 때 편하게 사용)
	func getSomeDayDate(intervalDay: Double) -> Date {
		let resultDate: Date
		if intervalDay > 0 {
			resultDate = Date(timeInterval: 86400 * intervalDay, since: self)
		} else {
			resultDate = Date(timeInterval: -86400 * fabs(intervalDay), since: self)
		}
		return resultDate
	}

	// 두 개의 Date의 차이를 리턴해준다 (최대 10일까지만 조회 가능하도록 할 때 편하게 사용)
	func getIntervalDays(date: Date?, anotherDay: Date? = nil) -> Double {
		var interval: Double!
		if anotherDay == nil {
			interval = date?.timeIntervalSinceNow
		} else {
			interval = date?.timeIntervalSince(anotherDay!)
		}
		let intervalDay = interval / 86400
		return floor(intervalDay)
	}
}
