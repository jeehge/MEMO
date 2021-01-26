//
//  MemoCreateViewController.swift
//  JHMemo
//
//  Created by JH on 2021/01/24.
//

import UIKit
import Photos
import RxSwift

final class MemoCreateViewController: BaseViewController {

	// MARK: - Properties
	@IBOutlet private weak var contentView: UIView!
	@IBOutlet private weak var todayDateView: UIView!
	@IBOutlet private weak var todayDateLabel: UILabel!
	@IBOutlet private weak var memoImageView: UIImageView!
	@IBOutlet private weak var imageSelectButton: UIButton!
	@IBOutlet private weak var imageDeleteButton: UIButton!
	@IBOutlet private weak var hashTagTextView: UITextView!
	@IBOutlet private weak var completeButton: UIButton!
	@IBOutlet private weak var contentViewBottomConstraint: NSLayoutConstraint!

	private let imagePicker = UIImagePickerController()
	private var imagePath: String?

	// 기본 메모 정보를 담고 있는 memo info
	var updateMemo: MemoInfo?

	private let date: Date = Date()
	private var isCreateMemo: Bool {
		return updateMemo == nil ? true : false
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		initDefaltView()
		initImagePicker()
		bind()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		addNotification()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeNotification()
	}

	// MARK: - Initialize
	private func initDefaltView() {
		todayDateView.setRoundViewStyle(color: .white, cornerRadius: 8)
		hashTagTextView.setRoundViewStyle(color: .white, cornerRadius: 8)
		hashTagTextView.setHashTagTextViewStyle(size: 16)
		todayDateLabel.setBodyStyle(text: nil, size: 16)
		completeButton.setCompleteStyle(size: 16)
		setMemoData()
	}

	private func initImagePicker() {
		imagePicker.delegate = self
	}

	private func setMemoData() {
		imageDeleteButton.isHidden = isCreateMemo ? true : false
		imageSelectButton.isHidden = isCreateMemo ? false : true

		// 하단 버튼 텍스트 셋팅
		let completeButtonTitle: String = isCreateMemo ? "등록".localized : "수정".localized
		completeButton.setTitle(completeButtonTitle, for: .normal)

		// 오늘 날짜 셋팅
		let todayDate = date.getDateString(format: Constant.editDateFormat)
		todayDateLabel.text = todayDate

		guard let infoMemo = updateMemo else { return }

		// 메모 정보 셋팅
		todayDateLabel.text = infoMemo.memoDate

		// 해시태그가 없는 경우
		hashTagTextView.text = infoMemo.memoTag.isEmpty ? "내용없음".localized : infoMemo.memoTag

		// 메모 정보 - 이미지
		memoImageView.contentMode = .scaleAspectFit
		memoImageView.image = .loadImage(imageName: infoMemo.memoMediaPath)
	}

	// MARK: - Notification
	private func addNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func removeNotification() {
		NotificationCenter.default.removeObserver(self)
	}

	@objc func keyboardWillShow(_ sender: Notification) {
		guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
		contentViewBottomConstraint.constant = keyboardSize.height
		UIView.animate(withDuration: 0.30, animations: {
			self.view.layoutIfNeeded()
		})
	}

	@objc func keyboardWillHide(_ sender: Notification) {
		contentViewBottomConstraint.constant = 0
		UIView.animate(withDuration: 0.30, animations: {
			self.view.layoutIfNeeded()
		})
	}

	// MARK: - bind
	private func bind() {
		completeButton.rx.tap.bind { [weak self] in
			guard let self = self else { return }
			self.registerMemoInfo()
		}.disposed(by: disposeBag)

		imageSelectButton.rx.tap.bind { [weak self] in
			guard let self = self else { return }
			let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			let photo = UIAlertAction(title: "사진앨범".localized, style: .default) { (action) in
				self.openPhotoLibrary()
			}
			let camera = UIAlertAction(title: "카메라".localized, style: .default) { (action) in
				self.openCamera()
			}
			let drawing = UIAlertAction(title: "그리기".localized, style: .default) { (action) in
				self.openDrawing()
			}
			let cancel = UIAlertAction(title: "취소".localized, style: .cancel, handler: nil)
			alert.addAction(photo)
			alert.addAction(camera)
			alert.addAction(drawing)
			alert.addAction(cancel)
			self.present(alert, animated: true, completion: nil)
		}.disposed(by: disposeBag)

		imageDeleteButton.rx.tap.bind { [weak self] in
			guard let self = self else { return }
			// 처음 화면처럼 버튼 셋팅
			self.imageDeleteButton.isHidden = true
			self.imageSelectButton.isHidden = false

			UIView.animate(withDuration: 0.3, animations: {
				self.memoImageView.alpha = 0
				self.view.layoutIfNeeded()
			}, completion: { _ in
				// 선택한 이미지 제거
				self.memoImageView.image = nil
				self.memoImageView.alpha = 1
			})
		}.disposed(by: disposeBag)
	}

	// MARK: - Private Method
	// 필수값 체크
	private func isEmpty() -> Bool {
		if imagePath == nil && updateMemo?.memoMediaPath == nil {
			emptyCheck(content: "사진을 추가해주세요.".localized)
			return true
		}
		return false
	}

	// 공백체크 팝업
	private func emptyCheck(content: String) {
		let alert = UIAlertController(title: nil, message: content, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "확인".localized, style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	// 메모 등록
	private func registerMemoInfo() {
		if isEmpty() {
			return
		}

		let strDate = date.getDateString(format: Constant.dateFormat)
		var strTag = ""
		let arrTag = hashTagTextView.text.components(separatedBy: [" ", "\n", "\t", "#"])
		arrTag.forEach {
			if !$0.isEmpty {
				strTag += "#" + $0 + " "
			}
		}
		strTag = strTag.trimmingCharacters(in: .whitespacesAndNewlines)

		if isCreateMemo { // 메모 등록
			guard let mPath = imagePath else { return }
			let memoInfo = MemoInfo(seq: 0, date: strDate, tag: strTag, path: mPath)
			DBManager.shared.insertMemoData(info: memoInfo)
			if let listVC: MemoListViewController = self.presentingViewController as? MemoListViewController {
				listVC.reloadTableView()
				dismiss(animated: true, completion: nil)
			}
		} else { // 메모 수정
			guard let infoMemo = updateMemo else { return }
			let memoInfo = MemoInfo(seq: infoMemo.memoSeq, date: strDate, tag: strTag, path: infoMemo.memoMediaPath)
			DBManager.shared.updateMemoData(info: memoInfo)
			dismiss(animated: false, completion: nil)
			if let listVC: MemoListViewController = self.presentingViewController?.presentingViewController as? MemoListViewController {
				listVC.reloadTableView()
			}
			presentingViewController?.dismiss(animated: true, completion: nil)
		}
	}

	// MARK: - Touch Event
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
		contentViewBottomConstraint.constant = 0
	}
}

// MARK: - UIImagePickerControllerDelegate
extension MemoCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		// 키보드 내리기
		view.endEditing(true)
		contentViewBottomConstraint.constant = 0

		UIView.animate(withDuration: 0.30, animations: {
			self.view.layoutIfNeeded()
		})

		// 사진 불러오기 종료
		dismiss(animated: true, completion: { [weak self] in
			guard let self = self else { return }
			guard let pickedImage = info[.originalImage] as? UIImage else { return }

			let originalImage: UIImage = pickedImage.getOriginalImage()
			self.imagePath = originalImage.filePathCreate()
			self.memoImageView.contentMode = .scaleAspectFit
			self.memoImageView.image = originalImage

			 // 이미지가 등록된 시점
			 self.imageDeleteButton.isHidden = false
			 self.imageSelectButton.isHidden = true
			 self.memoImageView.isHidden = false
		})
	}

	// 사진앨범 열기
	func openPhotoLibrary() {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .photoLibrary
		present(imagePicker, animated: true, completion: nil)
	}

	// 카메라 열기
	func openCamera() {
		imagePicker.allowsEditing = false

		// 카메라 사용한 기기인지 확인
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
			imagePicker.sourceType = .camera
			present(imagePicker, animated: true, completion: nil)
		} else {
			print("CreateViewController - this device cannot use Camera")
			let alert = UIAlertController(title: nil, message: "카메라를 지원하지 않습니다.".localized, preferredStyle: .alert)
			let cancel = UIAlertAction(title: "취소".localized, style: .cancel, handler: nil)
			alert.addAction(cancel)
			present(alert, animated: true, completion: nil)
		}
	}

	func openDrawing() {
		let drawVC = DrawViewController.viewController(from: .edit)
		drawVC.delegate = self
		drawVC.modalPresentationStyle = .fullScreen
		drawVC.modalTransitionStyle = .crossDissolve
		present(drawVC, animated: true, completion: nil)
	}
}

// MARK: - DrawViewControllerDelegate
extension MemoCreateViewController: DrawViewControllerDelegate {
	func getDrawImage(image: UIImage?) {
		guard let drawImage = image else { return }

		imageSelectButton.isHidden = true
		imageDeleteButton.isHidden = false

		imagePath = drawImage.filePathCreate()
		memoImageView.image = drawImage
	}
}
