//
//  ImageActionSheetController.swift
//  JHMemo
//
//  Created by JH on 2021/01/24.
//

import UIKit

final class ImageActionSheetController: BaseViewController {
	// MARK: - Properties
	@IBOutlet private weak var stackView: UIStackView!
	@IBOutlet private weak var cancelButton: UIButton!
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .clear
	}
	
	// MARK: - Touch Event
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		dismiss(animated: true, completion: nil)
	}
}
