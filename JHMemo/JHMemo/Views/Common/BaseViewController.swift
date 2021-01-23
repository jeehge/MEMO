//
//  BaseViewController.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController, ViewControllerFromStoryBoard {
	
	let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(named: ColorName.background.description)
	}
}
