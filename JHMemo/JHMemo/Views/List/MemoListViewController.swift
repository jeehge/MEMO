//
//  MemoListViewController.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import UIKit
import RxSwift

final class MemoListViewController: BaseViewController {
	// MARK: - Properties
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var createButton: UIButton!
	@IBOutlet private weak var settingButton: UIButton!
	@IBOutlet private weak var emptyInfoLabel: UILabel!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var createButtonBottomConstraint: NSLayoutConstraint!
	@IBOutlet private weak var bannerView: UIView!

	private var memoList: [MemoInfo] = []

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		initTableView()
		initLabel()
	}

	// MARK: - initialize
	private func initTableView() {
		tableView.delegate = self
		tableView.dataSource = self

		reloadTableView()
	}

	private func initLabel() {
		emptyInfoLabel.text = "등록된 메모가 없습니다.".localized
		emptyInfoLabel.textAlignment = .center
		emptyInfoLabel.font = .systemFont(ofSize: 16)
		emptyInfoLabel.adjustsFontSizeToFitWidth = true

		titleLabel.setTitleStyle(text: "MEMO".localized, size: 33)
		createButton.setShadow()
	}

	private func bind() {
		let abservable: Observable<[MemoInfo]> = Observable.of(memoList)
		abservable.subscribe(onNext: { [weak self] list in
			if list.count == 0 {
				self?.tableView.isHidden = true
				self?.emptyInfoLabel.isHidden = false
			} else {
				self?.tableView.isHidden = false
				self?.emptyInfoLabel.isHidden = true
			}
		}).disposed(by: disposeBag)

		createButton.rx.tap.bind { [weak self] in
			guard let self = self else { return }
			let createVC: MemoCreateViewController = MemoCreateViewController.viewController(from: .edit)
			self.present(createVC, animated: true)
		}.disposed(by: disposeBag)

		settingButton.rx.tap.bind { [weak self] in
			guard let self = self else { return }
			let settingVC: SettingViewController = SettingViewController.viewController(from: .setting)
			settingVC.modalPresentationStyle = .fullScreen
			settingVC.modalTransitionStyle = .crossDissolve
			self.present(settingVC, animated: true)
		}.disposed(by: disposeBag)
	}

	func reloadTableView() {
		memoList = DBManager.shared.selectMemoData()
		tableView.reloadData()
		bind()
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UIScreen.main.bounds.size.width + 50
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memoList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let memoCell = tableView.dequeueReusableCell(withIdentifier: MemoCell.identifier, for: indexPath) as! MemoCell
		memoCell.setMemeoCell(info: memoList[indexPath.row])
		return memoCell
	}

	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return indexPath
	}

	// 선택된 이후에 대한 이벤트
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailVC = MemoDetailViewController.viewController(from: .list)
		detailVC.detailMemoInfo = memoList[indexPath.row]
		detailVC.modalTransitionStyle = .crossDissolve
		present(detailVC, animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? MemoCell else { return }
		cell.didHighlight(true)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? MemoCell else { return }
		cell.didHighlight(false)
	}

	// MARK: - UIScrollViewDelegate
	// 사용자가 스크롤을 끝냈을때 알림
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

		// velocity : 터치가 해제된 스크롤뷰 순간 속도
		if velocity.y > 0 {
			UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.createButtonBottomConstraint.constant = -200 // button constraint 위치 조절
				self.bannerView.alpha = 0
				UIView.animate(withDuration: 0.20, animations: {
					self.view.layoutIfNeeded()
				})

				// 일정 시간이 지나면 내려간 버튼 다시 올라오도록
				Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
					UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
						self.createButtonBottomConstraint.constant = 8 // button constraint 위치 조절
						self.bannerView.alpha = 1
						UIView.animate(withDuration: 0.20, animations: {
							self.view.layoutIfNeeded()
						})
					})
				}
			})
		} else {
			UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.createButtonBottomConstraint.constant = 8 // button constraint 위치 조절
				self.bannerView.alpha = 1
				UIView.animate(withDuration: 0.20, animations: {
					self.view.layoutIfNeeded()
				})
			})
		}
	}
}
