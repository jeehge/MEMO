//
//  URL+Extension.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import Foundation

extension URL {
	// 파일 경로 불러오기
	static func loadFilePath(imageName: String) -> URL? {
		let fileManager = FileManager.default

		let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
		let strPath = documentDirectory.appending("/\(imageName)")

		if fileManager.fileExists(atPath: strPath) {
			let fileURL = URL(fileURLWithPath: strPath)
			return fileURL
		} else {
			print("Error loading faile path")
		}
		return nil
	}
}
