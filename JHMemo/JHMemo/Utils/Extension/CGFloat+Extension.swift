//
//  CGFloat+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/24.
//

import UIKit

// CGFloat와 Double에 대한 값을 iPhoneX 가로 사이즈 (375) 비율로 적용한 방법
extension CGFloat {
	var adjused: CGFloat {
		let ratio: CGFloat = UIScreen.main.bounds.width / 375
		return self * ratio
	}
}
