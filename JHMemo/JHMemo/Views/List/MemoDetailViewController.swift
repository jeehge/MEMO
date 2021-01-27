//
//  MemoDetailViewController.swift
//  JHMemo
//
//  Created by JH on 2021/01/27.
//

import UIKit
import RxSwift
import Photos

final class MemoDetailViewController: BaseViewController {
	// MARK: - Properties
	@IBOutlet private weak var contentImageVIew: UIImageView!
	@IBOutlet private weak var bgImageView: UIImageView!
	@IBOutlet private weak var hashTagTextView: UITextView!
	@IBOutlet private weak var todayDateLabel: UILabel!
	@IBOutlet private weak var updateButton: UIButton!
	@IBOutlet private weak var deleteButton: UIButton!
	@IBOutlet private weak var downloadBackView: UIView!
	@IBOutlet private weak var downloadButton: UIButton!

	var detailMemoInfo: MemoInfo?

	override var prefersStatusBarHidden: Bool {
		return true
	}

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		initDefaltView()
		settingDetailView()
		bind()
	}

	// MARK: - Initialize
	private func initDefaltView() {
		todayDateLabel.setBodyStyle(text: nil, size: 14)
		hashTagTextView.font = .systemFont(ofSize: 16)
		downloadBackView.layer.cornerRadius = downloadButton.frame.width / 2

		updateButton.setConfirmStyle(text: "수정".localized, size: 12)
		deleteButton.setCancelStyle(text: "삭제".localized, size: 12)

		settingImageView()
	}

	private func bind() {
		// 수정 버튼
		updateButton.rx.tap.bind { [weak self] in
			let updateVC = MemoCreateViewController.viewController(from: .edit)
			updateVC.updateMemo = self?.detailMemoInfo
			updateVC.modalTransitionStyle = .crossDissolve
			self?.present(updateVC, animated: true)
		}.disposed(by: disposeBag)

		// 삭제 버튼
		deleteButton.rx.tap.bind { [weak self] in
			self?.alert(title: "해당 내용을 삭제할까요？".localized, message: "삭제하게 되면 복구가 불가능합니다.".localized, okTitle: "삭제".localized, okHandler: { _ in
				if let info = self?.detailMemoInfo {
					DBManager.shared.deleteMemoData(info: info)
					if let listVC: MemoListViewController = self?.presentingViewController as? MemoListViewController {
						listVC.reloadTableView()
						self?.dismiss(animated: true)
					}
				} else {
					print("detail memo info is nil")
				}
			}, cancelTitle: "취소".localized)
		}.disposed(by: disposeBag)

		downloadButton.rx.tap.bind { [weak self] in
			self?.alert(message: "이미지를 저장하시겠습니까?".localized, okTitle: "저장".localized, okHandler: { _ in
				self?.saveGalleryImage()
			}, cancelTitle: "취소".localized)
		}.disposed(by: disposeBag)
	}

	// MARK: - private Method
	private func settingDetailView() {
		// 해시태그가 없는 경우
		if detailMemoInfo?.memoTag.isEmpty ?? true {
			hashTagTextView.text = "내용없음".localized
		} else {
			hashTagTextView.text = detailMemoInfo?.memoTag
		}

		let mDate = detailMemoInfo?.memoDate
		if let strDate = mDate?.getStringDate(format: Constant.dateFormat) {
			let memoDate = strDate.getDateString(format: Constant.dateFormat)
			todayDateLabel.text = memoDate
		} else {
			guard let strDate = mDate?.getStringDate(format: Constant.previousDateFormat) else { return }
			let memoDate = strDate.getDateString(format: Constant.dateFormat)
			todayDateLabel.text = memoDate
		}
	}

	private func settingImageView() {
		view.clipsToBounds = true

		guard let mediaPath = detailMemoInfo?.memoMediaPath else { return }
		bgImageView.alpha = 0.0
		bgImageView.clipsToBounds = true
		bgImageView.contentMode = .scaleAspectFill
		bgImageView.image = .loadImage(imageName: mediaPath)

		contentImageVIew.contentMode = .scaleAspectFit
		contentImageVIew.image = .loadImage(imageName: mediaPath)
	}

	private func saveGalleryImage() {
		if PHPhotoLibrary.authorizationStatus() == .authorized {
			imageSave()
		} else {
			PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
				if status == .authorized {
					self?.imageSave()
				}
			})
		}
	}

	private func imageSave() {
		do {
			guard let path: String = detailMemoInfo?.memoMediaPath else { return }
			guard let url = URL.loadFilePath(imageName: path) else { return }
			let data: Data = try Data.init(contentsOf: url)
			guard let image: UIImage = UIImage(data: data) else { return }
			UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
		} catch {
			print("Error saved image : \(error.localizedDescription)")
		}
	}

	@objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if error == nil {
			alert(title: "성공!".localized, message: "이미지가 사진에 저장되었습니다.".localized, okTitle: "확인".localized)
		} else {
			alert(title: "실패!".localized, message: error?.localizedDescription, okTitle: "확인".localized)
		}
	}
}
