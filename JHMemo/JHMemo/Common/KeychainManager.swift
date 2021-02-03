//
//  KeychainManager.swift
//  JHMemo
//
//  Created by JH on 2021/02/04.
//

import KeychainSwift

final class KeychainManager {
	static let keychain: KeychainSwift = {
		let keychain = KeychainSwift()
		let appIDPrefix = "4U3LY873Q2"
		keychain.accessGroup = "\(appIDPrefix).com.jhmemo.projectjh.keychainGroup"
		return keychain
	}()

	static var widgetMemoInfo: MemoInfo {
		get {
			return unarchive(data: keychain.getData("widgetMemo") ?? Data())
		}
		set {
			let memoData = archive(memo: newValue)
			KeychainManager.keychain.set(memoData, forKey: "widgetMemo")
		}
	}

	static func archive(memo: MemoInfo) -> Data {
		var myMemo = memo
		return Data(bytes: &myMemo, count: MemoryLayout<MemoInfo>.stride)
	}

	static func unarchive(data: Data) -> MemoInfo {
		guard data.count == MemoryLayout<MemoInfo>.stride else {
			fatalError("Error!")
		}

		var myMemo: MemoInfo?

		data.withUnsafeBytes { (bytes: UnsafePointer<MemoInfo>) -> Void in
			myMemo = UnsafePointer<MemoInfo>(bytes).pointee
		}
		return myMemo!
	}
}
