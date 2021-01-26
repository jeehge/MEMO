//
//  MemoInfo.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

struct MemoInfo {
	// MARK: - Properties
	var memoSeq: Int            // 필수값
	var memoDate: String        // 필수값
	var memoTag: String         // 필수값
	var memoMediaPath: String   // 필수값

	// MARK: - Initialize
	init(seq: Int, date: String, tag: String, path: String) {
		self.memoSeq = seq
		self.memoDate = date
		self.memoTag = tag
		self.memoMediaPath = path
	}
}
