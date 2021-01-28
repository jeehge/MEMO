//
//  FileManagerHelper.swift
//  JHMemo
//
//  Created by JH on 2021/01/28.
//

import Foundation

final class FileManagerHelper {
	
	static let shared: FileManagerHelper = FileManagerHelper()
	
	private let fileManager = FileManager.default
	private var documentDirectory: String = ""
	
	// MARK: - Initialize
	private init() {
		documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
	}
	
	// 파일 경로 불러오기
	func loadFilePath(imageName: String) -> URL? {
		let strPath = documentDirectory.appending("/\(imageName)")
		if fileManager.fileExists(atPath: strPath) {
			let fileURL = URL(fileURLWithPath: strPath)
			return fileURL
		} else {
			print("👻 Error loading faile path")
			return nil
		}
	}
}
