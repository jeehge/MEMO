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
		guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else 
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

	// 이미지 로드
	static func loadImage(imageName: String) -> UIImage {
		let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
		let strPath = documentDirectory.appending("/\(imageName)")
		let fileURL = URL(fileURLWithPath: strPath)
		do {
			let imageData = try Data(contentsOf: fileURL)
			guard let image = UIImage(data: imageData) else { return UIImage()}
			return image
		} catch {
			print("Error loading image : \(error)")
		}
		return UIImage()
	}

	// 파일 경로 생성
	func filePathCreate() -> String {
		var resultImagePath: String = ""

		// default FileManager 객체에 대한 참조체 얻기
		let fileManager = FileManager.default

		// 파일명
		let imageName = UUID().uuidString

		// get the image path
		// Documents 외에 속성을 보면 다른 많은 디렉터리를 확인할 수 있다.
		let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String).appending("/\(imageName)" + ".jpg")

		// get the PNG data for this image
		let data = self.pngData()

		// store it in the document directory
		fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
		resultImagePath = imageName + ".jpg"
		return resultImagePath
	}
}
