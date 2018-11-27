//
//  Graph.swift
//  DanalMobile
//
//  Created by BENJAMIN BRYANT BUDIMAN on 05/09/18.
//  Copyright © 2018 Danal, Inc. All rights reserved.
//

import UIKit

class Graph: UIView {

	var values = [Int](1...8760)
	var relevantValues: [Int] {
		var values = Array(self.values[(self.values.endIndex - displayNumber.last)...])
		values = zip(values.indices, values).reduce([0]) { partialValues, iv in
			var partialValues = partialValues
			partialValues[partialValues.count - 1] += iv.1
			let mod = values.count / displayNumber.gradations
			if iv.0 % mod == mod - 1 {
				partialValues.append(0)
			}
			return partialValues
		}
		values.removeLast()
		return values
	}

	var displayNumber = (last: 0, gradations: 0) {
		didSet {
			drawGraph()
		}
	}

	override func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		values = values.reduce([]) { (values, index) in
			let random = (Int(arc4random()) * 100 / Int(UInt32.max)) - 49
			return values + [(values.last ?? 0) + random]
		}
		if let min = values.min() {
			values = values.map {
				$0 - min
			}
		}
	}

	func drawGraph() {
		layer.sublayers = nil

		let values = relevantValues

		let minimum = values.min() ?? 0
		let maximum = values.max() ?? 0
		let difference = maximum - minimum

		guard values.count > 0 else {
			return
		}

		let frame = self.frame.insetBy(dx: 20, dy: 10)

		for i in values.indices {
			let scale = UIBezierPath()
			scale.move(to: CGPoint(x: frame.minX + frame.width * CGFloat(i) / CGFloat(values.count - 1), y: frame.minY))
			scale.addLine(to: CGPoint(x: frame.minX + frame.width * CGFloat(i) / CGFloat(values.count - 1), y: frame.maxY))
			let scaleShapeLayer = CAShapeLayer()
			scaleShapeLayer.frame = layer.frame
			scaleShapeLayer.path = scale.cgPath
			scaleShapeLayer.strokeColor = UIColor.lightGray.cgColor
			scaleShapeLayer.fillColor = nil
			scaleShapeLayer.lineWidth = 1
			layer.addSublayer(scaleShapeLayer)
		}

		let axes = UIBezierPath()
		axes.move(to: frame.topLeftCorner)
		axes.addLine(to: frame.bottomLeftCorner)
		axes.addLine(to: frame.bottomRightCorner)
		let axesShapeLayer = CAShapeLayer()
		axesShapeLayer.frame = layer.frame
		axesShapeLayer.path = axes.cgPath
		axesShapeLayer.strokeColor = UIColor.black.cgColor
		axesShapeLayer.fillColor = nil
		axesShapeLayer.lineWidth = 2
		layer.addSublayer(axesShapeLayer)

		let graph = UIBezierPath()
		graph.move(to: frame.bottomLeftCorner)
		for i in values.indices {
			let value = values[i]
			graph.addLine(to: CGPoint(x: frame.minX + frame.width * CGFloat(i) / CGFloat(values.count - 1), y: frame.height + frame.minY - frame.height * CGFloat(value - minimum) / CGFloat(difference)))
		}
		graph.addLine(to: frame.bottomRightCorner)
		graph.close()
		let graphShapeLayer = CAShapeLayer()
		graphShapeLayer.frame = layer.frame
		graphShapeLayer.path = graph.cgPath
		graphShapeLayer.fillColor = UIColor.blue.withAlphaComponent(0.5).cgColor
		graphShapeLayer.lineWidth = 1
		layer.addSublayer(graphShapeLayer)
	}

}

extension CGRect {
	var topLeftCorner: CGPoint {
		get {
			return CGPoint(x: minX, y: minY)
		}
	}
	var topRightCorner: CGPoint {
		get {
			return CGPoint(x: maxX, y: minY)
		}
	}
	var bottomLeftCorner: CGPoint {
		get {
			return CGPoint(x: minX, y: maxY)
		}
	}
	var bottomRightCorner: CGPoint {
		get {
			return CGPoint(x: maxX, y: maxY)
		}
	}
}
