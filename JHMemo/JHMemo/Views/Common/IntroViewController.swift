//
//  IntroViewController.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import UIKit

final class IntroViewController: BaseViewController {
	// MARK: - Properties
	@IBOutlet private weak var titleLabel: UILabel!
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initIntroAnimation()
	}
	
	private func initIntroAnimation() {
		self.titleLabel.text = "지혜로운 메모 :)".localized
		self.titleLabel.alpha = 0
		
		UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveLinear, animations: {
			var frame = self.titleLabel.frame
			frame.origin.x = frame.origin.x + 150
			self.titleLabel.frame = frame
			self.titleLabel.alpha = 1
		}, completion: { _ in
			self.nextMainViewController()
		})
	}
	
	private func nextMainViewController() {
		let listVC: MemoListViewController = MemoListViewController.viewController(from: .list)
		listVC.modalPresentationStyle = .fullScreen
		listVC.modalTransitionStyle = .crossDissolve
		present(listVC, animated: true, completion: nil)
	}
}
