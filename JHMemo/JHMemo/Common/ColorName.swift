//
//  ColorName.swift
//  JHMemo
//
//  Created by JH on 2021/01/23.
//

enum ColorName: String, CustomStringConvertible {
	case background
	case text
	case title
	case shadow
	case button

	var description: String {
		switch self {
		case .background: return "background"
		case .text: return "text"
		case .title: return "title"
		case .shadow: return "shadow"
		case .button: return "button"
		}
	}
}
