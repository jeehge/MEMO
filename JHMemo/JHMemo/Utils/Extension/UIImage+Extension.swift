//
//  UIImage+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/24.
//

import UIKit

extension UIImage {
	// 이미지 크기 조정: 너비기준!
	static func resizeWithWidth(image: UIImage, resizeWidth: CGFloat) -> UIImage {
		// 오리지널 이미지 크기
		let originalSize = image.size
		let widthRatio = UIScreen.main.bounds.size.width / originalSize.width
		let heightRatio = UIScreen.main.bounds.size.height / originalSize.height

		var newSize: CGSize
		if widthRatio > heightRatio {
			newSize = CGSize(width: originalSize.width * heightRatio, height: originalSize.height * heightRatio)
		} else {
			newSize = CGSize(width: originalSize.width * widthRatio, height: originalSize.height * widthRatio)
		}

		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		image.draw(in: rect)
		guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
			return UIImage()
		}
		UIGraphicsEndImageContext()
		return newImage
	}

	func getOriginalImage() -> UIImage {
		// 오리지널 이미지 크기
		let originalSize = self.size
		let rect = CGRect(x: 0, y: 0, width: originalSize.width, height: originalSize.height)

		UIGraphicsBeginImageContextWithOptions(originalSize, false, 1.0)
		self.draw(in: rect)
		guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
			return UIImage()
		}
		UIGraphicsEndImageContext()
		return newImage
	}
}
