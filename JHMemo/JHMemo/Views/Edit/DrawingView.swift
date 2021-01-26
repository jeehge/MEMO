//
//  DrawingView.swift
//  JHMemo
//
//  Created by JH on 2021/01/25.
//

import UIKit

struct LineInfo {
	let color: UIColor
	let lineWidth: CGFloat
	let line: UIBezierPath
}

final class DrawingView: UIView {
	// MARK: - Properties
	private var drawColor = UIColor.black	// 선 색
	private var lineWidth: CGFloat = 5   	// 선의 폭
	private var bezierPath: UIBezierPath = UIBezierPath()
	private var lastPoint: CGPoint?     	// 마지막 위치를 저장
	private var pointCounter: Int = 0   	// point 카운터
	private let pointLimit: Int = 128
	private var preRenderImage: UIImage?
	private var allLine: [LineInfo] = []
	private var cancelLine: [LineInfo] = []

	// MARK: - Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		initBezierPath()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initBezierPath()
	}

	private func initBezierPath() {
		lastPoint = .zero
		bezierPath.lineCapStyle = CGLineCap.round       // 끝점 모양
		bezierPath.lineJoinStyle = CGLineJoin.round     // 연결 모양
	}
	// MARK: - Touch handling
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: AnyObject? = touches.first
		guard let currentPoint = touch?.location(in: self) else { return }
		bezierPath.move(to: currentPoint)
		lastPoint = currentPoint

		let tmpDic = LineInfo(color: drawColor, lineWidth: lineWidth, line: bezierPath)
		allLine.append(tmpDic)

		// pointCounter 재설정
		pointCounter = 0
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: AnyObject? = touches.first
		guard let currentPoint = touch?.location(in: self) else { return }
		let midPoint = self.midPoint(from: lastPoint!, to: currentPoint)

		// bezierPath에 point 추가
		bezierPath.addQuadCurve(to: midPoint, controlPoint: lastPoint!)
		lastPoint = currentPoint

		// pointCounter 증가
		pointCounter += 1

		setNeedsDisplay()
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		// pointCounter 재설정
		pointCounter = 0
		renderToImage()
		setNeedsDisplay()

		// bezierPath 재설정
		bezierPath.removeAllPoints()
	}

	override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
		touchesEnded(touches!, with: event)
	}

	// MARK: - Pre render
	// bezierPath path를 UIImage에 렌더링
	private func renderToImage() {
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
		if preRenderImage != nil {
			preRenderImage?.draw(in: self.bounds)
		}

		bezierPath.lineWidth = lineWidth
		drawColor.setFill()
		drawColor.setStroke()
		bezierPath.stroke()

		preRenderImage = UIGraphicsGetImageFromCurrentImageContext()

		UIGraphicsEndImageContext()
	}

	// MARK: - Render
	override func draw(_ rect: CGRect) {
		super.draw(rect)

		if preRenderImage != nil {
			preRenderImage?.draw(in: self.bounds)
		}

		allLine.forEach {
			$0.color.setStroke()
			$0.line.lineWidth = $0.lineWidth
			$0.line.stroke()
		}
	}

	// MARK: - Clearing : 그려진 path들 지움
	func clear() {
		preRenderImage = nil
		bezierPath.removeAllPoints()
		setNeedsDisplay()
	}

	func cancel() {
		bezierPath.close()
	}

	func save() -> UIImage? {
		return preRenderImage
	}

	// MARK: - Other
	// 선을 확인하는 경우
	private func hasLines() -> Bool {
		return preRenderImage != nil || !bezierPath.isEmpty
	}

	private func midPoint(from point0: CGPoint, to point1: CGPoint) -> CGPoint {
		let pointX = (point0.x + point1.x) / 2
		let pointY = (point0.y + point1.y) / 2
		return CGPoint(x: pointX, y: pointY)
	}

	private func backImage() {
		if allLine.isEmpty == false {
			cancelLine.append(allLine.last!)
			allLine.removeLast()
			setNeedsDisplay()
		}
	}

	private func forwardImage() {
		if cancelLine.isEmpty == false {
			allLine.append(cancelLine.last!)
			cancelLine.removeLast()
			setNeedsDisplay()
		}
	}
}
