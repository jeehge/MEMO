//
//  dd.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

import UIKit

protocol CellIdentifierable { }

extension CellIdentifierable where Self: UITableViewCell {
	static var identifier: String {
		return String(describing: self)
	}
}

extension UITableViewCell: CellIdentifierable { }
