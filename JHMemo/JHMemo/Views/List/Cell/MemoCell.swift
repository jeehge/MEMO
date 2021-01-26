//
//  MemoCell.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import UIKit
import Kingfisher

final class MemoCell: UITableViewCell {
	// MARK: - Properties
	@IBOutlet private weak var cellView: UIView!
	@IBOutlet private weak var shadowView: UIView!
	@IBOutlet private weak var thumbnailImageView: UIImageView!
	@IBOutlet private weak var hashTagLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		configureMemoCell()
	}

	// MARK: - Initialize
	private func configureMemoCell() {
		// 이미지 contentMode
		thumbnailImageView.contentMode = .scaleAspectFill

		// 모서리 둥글게
		cellView.clipsToBounds = true
		cellView.layer.cornerRadius = cellView.frame.width / 12

		// 그림자
		shadowView.layer.masksToBounds = false
		shadowView.layer.cornerRadius = shadowView.frame.width / 12
		shadowView.layer.shadowColor = UIColor.darkGray.cgColor
		shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
		shadowView.layer.shadowOpacity = 0.2

		hashTagLabel.textColor = UIColor(named: ColorName.text.description)
	}

	// MARK: - Setting Cell
	func setMemeoCell(info: MemoInfo) {
		hashTagLabel.text = info.memoTag.isEmpty ? "내용없음".localized : info.memoTag

		if let url = URL.loadFilePath(imageName: info.memoMediaPath) {
			let provider = LocalFileImageDataProvider(fileURL: url)
			thumbnailImageView.kf.setImage(with: provider)
		}
	}

	func didHighlight(_ isHighlight: Bool) {
		UIView.animate(withDuration: 0.5) {
			self.cellView.transform = isHighlight ? .init(scaleX: 0.95, y: 0.95) : .identity
			self.shadowView.transform = isHighlight ? .init(scaleX: 0.95, y: 0.95) : .identity
		}
	}
}
