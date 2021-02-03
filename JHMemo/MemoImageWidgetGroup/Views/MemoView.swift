//
//  MemoView.swift
//  JHMemo
//
//  Created by JH on 2021/02/03.
//

import SwiftUI

struct MemoView: View {

    var body: some View {
		VStack {
			Text("오늘은 무슨 일이 있었나요?".localized)
				.fontWeight(.ultraLight)
				.font(.system(size: 20))
				.lineLimit(2)
				.padding()

//			if let url = FMManger.shared.loadFilePath(imageName: memoInfo.memoMediaPath) {
//				let provider = LocalFileImageDataProvider(fileURL: url)
//			}
		}
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoView()
    }
}
