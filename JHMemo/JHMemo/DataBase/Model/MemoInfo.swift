//
//  MemoInfo.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

struct MemoInfo {
	
	/**
	 
	 optional인 이유가 있나요?
	 필수값이라고 한다면 init 과정에서 전부 받아야 이 아이를
	 쓸수있도록 하는게 어떨까요
	 
	 */
	
	// MARK: - Properties
	var memoSeq: Int            // 필수값
	var memoDate: String        // 필수값
	var memoTag: String         // 필수값
	var memoMediaPath: String   // 필수값
	
	// MARK: - Initialize
	init(seq: Int, date: String, tag:String, path: String) {
		self.memoSeq = seq
		self.memoDate = date
		self.memoTag = tag
		self.memoMediaPath = path
	}
}
