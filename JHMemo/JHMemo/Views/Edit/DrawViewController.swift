//
//  DrawViewController.swift
//  JHMemo
//
//  Created by JH on 2021/01/25.
//

import UIKit

protocol DrawViewControllerDelegate: class {
	func getDrawImage(image: UIImage?)
}

final class DrawViewController: BaseViewController {
	// MARK: - Properties
	@IBOutlet private weak var drawingView: DrawingView!
	@IBOutlet private weak var closeButton: UIButton!
	@IBOutlet private weak var clearButton: UIButton!
	@IBOutlet private weak var completButton: UIButton!
	@IBOutlet private weak var infoLabel: UILabel!
	@IBOutlet private weak var closeButtonTopContraint: NSLayoutConstraint!

	weak var delegate: DrawViewControllerDelegate?

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		initButton()
		initEvent()
		initTextLabel()
	}

	// MARK: - Initialize
	private func initButton() {
		// 상단 높이 조절
		guard let window = UIWindow.key else { return }
		closeButtonTopContraint.constant = window.safeAreaInsets.top + 8
	}

	private func initEvent() {
		Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
			self.infoLabel.isHidden = true
		}
	}

	private func initTextLabel() {
		infoLabel.setBodyStyle(text: "이 곳에 메모해주세요.".localized, size: 14)
	}

	// MARK: - IBAction
	// 지우기 버튼
	@IBAction private func actionClear(_ sender: UIButton) {
		drawingView.clear()
	}

	@IBAction private func actionComplet(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
		delegate?.getDrawImage(image: self.drawingView.save())
	}

	@IBAction private func actionClose(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
}
