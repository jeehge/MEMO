//
//  DBManager.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import SQLite3
import FMDB

// https://www.appcoda.com/fmdb-sqlite-database/
final class DBManager {

	static let shared: DBManager = DBManager()

	private static let dbFileName = "database.sqlite"

	// table MEMO
	private let memoSeq = "memo_seq"
	private let memoDate = "memo_date"
	private let memoTag = "memo_tag"
	private let memoPath = "memo_image_path"

	// MARK: - Initialize
	private init() {
		// create memo table
		createMemoTablesIfNeeded()
	}

	private func loadDatabase() -> FMDatabase {
		let documentDirectory: String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
		let path = documentDirectory.appending("/\(DBManager.dbFileName)")
		return FMDatabase(path: path)
	}

	private func createMemoTablesIfNeeded() {
		let database = loadDatabase()
		guard database.open() else { assertionFailure("Database not opeend."); return }
		guard database.tableExists("MEMO") == false else { return }

		if database.isOpen {
			let createMemoTableQuery = "create table MEMO (\(memoSeq) integer primary key autoincrement not null, \(memoDate) text not null, \(memoTag) text not null, \(memoPath) text not null)"

			do {
				try database.executeUpdate(createMemoTableQuery, values: nil)
			} catch {
				assertionFailure("DataBaseManager - Could not create table: \(error.localizedDescription)")
			}
			database.close()
		}
	}

	// 입력
	func insertMemoData(info: MemoInfo) {
		let database = loadDatabase()
		if database.open() {
			let mDate   = info.memoDate
			let mTag    = info.memoTag
			let mPath   = info.memoMediaPath
			let query   = "insert into MEMO(\(memoDate), \(memoTag), \(memoPath)) values ('\(mDate)', '\(mTag)', '\(mPath)')"

			do {
				try database.executeUpdate(query, values: nil)
			} catch {
				print("DataBaseManager - Failed to insert initial data into the database.")
				print(database.lastError(), database.lastErrorMessage())
			}

			database.close()
		}
	}

	// 조회
	func selectMemoData() -> [MemoInfo] {
		var memoDic: [MemoInfo] = []
		let database = loadDatabase()
		if database.open() {
			let query = "select * from MEMO order by \(memoDate) desc"
			do {
				let results = try database.executeQuery(query, values: nil)
				while results.next() {
					let mSeq = Int(results.int(forColumn: memoSeq))
					if  let mDate   = results.string(forColumn: memoDate),
						let mTag    = results.string(forColumn: memoTag),
						let mPath   = results.string(forColumn: memoPath) {
						let memo    = MemoInfo(seq: mSeq, date: mDate, tag: mTag, path: mPath)
						memoDic.append(memo)
					}
				}
			} catch {
				print("DataBaseManager - ")
				print(error.localizedDescription)
			}

			database.close()
		}

		return memoDic
	}

	// 삭제
	func deleteMemoData(info: MemoInfo) {
		let database = loadDatabase()
		if database.open() {
			let mSeq = info.memoSeq
			let query = "delete from MEMO where \(memoSeq) = \(mSeq)"
			do {
				try database.executeUpdate(query, values: nil)
			} catch {
				print("DataBaseManager - Failed to insert initial data into the database.")
				print(database.lastError(), database.lastErrorMessage())
			}

			database.close()
		}
	}

	// 수정
	func updateMemoData(info: MemoInfo) {
		let database = loadDatabase()
		if database.open() {
			let mSeq    = info.memoSeq
			let mDate   = info.memoDate
			let mTag    = info.memoTag
			let mPath   = info.memoMediaPath
			let query   = "UPDATE MEMO SET \(memoDate)='\(mDate)',\(memoTag)='\(mTag)',\(memoPath)='\(mPath)' WHERE \(memoSeq) ='\(mSeq)'"

			do {
				try database.executeUpdate(query, values: nil)
			} catch {
				print("DataBaseManager - Failed to insert initial data into the database.")
				print(database.lastError(), database.lastErrorMessage())
			}

			database.close()
		}
	}
}
