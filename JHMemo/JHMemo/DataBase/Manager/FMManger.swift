//
//  FMManger.swift
//  JHMemo
//
//  Created by JH on 2021/01/28.
//

import UIKit

final class FMManger {

	static let shared: FMManger = FMManger()

	private let fileManager = FileManager.default
	private var documentDirectory: URL
	private let extensionValue: String = ".jpg"

	// MARK: - Initialize
	private init() {
		documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
	}

	// 파일 경로 불러오기
	func loadFilePath(imageName: String) -> URL? {
		let strPath = documentDirectory.appendingPathComponent(imageName)
		return strPath
	}

	// 이미지 로드
	func loadImage(imageName: String) -> UIImage? {
		let strPath = documentDirectory.appendingPathComponent(imageName)
		do {
			let imageData = try Data(contentsOf: strPath)
			guard let image = UIImage(data: imageData) else { return UIImage()}
			return image
		} catch {
			print("👻 Error loading image : \(error)")
			return nil
		}
	}

	// 파일 경로 생성
	func filePathCreate(image: UIImage) -> String {
		let imageName = UUID().uuidString	// 파일명

		// get the image path
		// Documents 외에 속성을 보면 다른 많은 디렉터리를 확인할 수 있다.
		let imagePath = documentDirectory.appendingPathComponent(imageName + extensionValue).path

		// store it in the document directory
		fileManager.createFile(atPath: imagePath, contents: image.pngData(), attributes: nil)

		let resultImagePath = imageName + extensionValue
		return resultImagePath
	}

}
