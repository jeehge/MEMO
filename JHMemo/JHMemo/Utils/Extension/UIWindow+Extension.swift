//
//  UIWindow+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/26.
//

import UIKit

extension UIWindow {
	static var key: UIWindow? {
		if #available(iOS 13, *) {
			return UIApplication.shared.windows.first { $0.isKeyWindow }
		} else {
			return UIApplication.shared.keyWindow
		}
	}
}
