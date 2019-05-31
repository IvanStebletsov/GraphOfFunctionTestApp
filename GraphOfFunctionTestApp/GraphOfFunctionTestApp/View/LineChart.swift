//
//  LineChart.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 31/05/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import UIKit

class LineChart: UIView {
    
    // MARK: - Properties
    let lineLayer = CAShapeLayer()
    let markersLayer = CAShapeLayer()
    
    var chartTransform: CGAffineTransform?
    
    var lineLayerColor = UIColor.white
    var markersLayerColor = UIColor.white
    var lineWidth: CGFloat = 1
    var markersSize: CGFloat = 4
    
    var axisColor: UIColor = UIColor.white
    var axisLineWidth: CGFloat = 1
    
    var stepX: CGFloat = 10
    var stepY: CGFloat = 10
    var drawGrid = false
    var xMax: CGFloat = 300
    var yMax: CGFloat = 300
    var xMin: CGFloat = 0
    var yMin: CGFloat = 0
    var labelFontSize: CGFloat = 14
    
    var linePoints: [CGPoint]?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(lineLayer)
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineLayerColor.cgColor
        
        layer.addSublayer(markersLayer)
        markersLayer.fillColor = markersLayerColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let chartTransform = chartTransform else { return }
        drawAxes(in: context, using: chartTransform)
    }
    
    func drawAxes(in context: CGContext, using transform: CGAffineTransform) {
        context.saveGState()
        
        let axesLines = CGMutablePath()
        
        let xAxisPoints = [CGPoint(x: xMin, y: 0), CGPoint(x: xMax, y: 0)] // TODO: - Положение оси X
        let yAxisPoints = [CGPoint(x: 0, y: yMin), CGPoint(x: 0, y: yMax)] // TODO: - Положение оси Y
        
        axesLines.addLines(between: xAxisPoints, transform: transform)
        axesLines.addLines(between: yAxisPoints, transform: transform)
        
        // finally set stroke color & line width then stroke thick lines, repeat for thin
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(axisLineWidth)
        context.addPath(axesLines)
        context.strokePath()
        
        drawGrid(in: context, using: transform)
        context.strokePath()
        
        context.restoreGState()
        // whenever you change a graphics context you should save it prior and restore it after
        // if we were using a context other than draw(rect) we would have to also end the graphics context
    }
    
    func drawGrid(in context: CGContext, using transform: CGAffineTransform) {
        let gridLines = CGMutablePath()
        
        for x in stride(from: xMin, through: xMax, by: stepX) {
            let tickPoints = [CGPoint(x: x, y: yMin).applying(transform), CGPoint(x: x, y: yMax).applying(transform)]
            
            gridLines.addLines(between: tickPoints)
            
            if x != xMin {
                let label = "\(Int(x))" as NSString
                let labelSize = "\(Int(x))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: x, y: 0).applying(transform).adding(x: -labelSize.width / 2).adding(y: 3)
                
                label.draw(at: labelDrawPoint, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: labelFontSize),
                                                                NSAttributedString.Key.foregroundColor: axisColor])
            }
        }
        
        for y in stride(from: yMin, through: yMax, by: stepY) {
            let tickPoints = [CGPoint(x: xMin, y: y).applying(transform), CGPoint(x: xMax, y: y).applying(transform)]
            
            gridLines.addLines(between: tickPoints)
            
            if y != yMin {
                let label = "\(Int(y))" as NSString
                let labelSize = "\(Int(y))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: 0, y: y).applying(transform).adding(x: -labelSize.width - 3).adding(y: -labelSize.height / 2)
                
                label.draw(at: labelDrawPoint, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: labelFontSize),
                                                                NSAttributedString.Key.foregroundColor: axisColor])
            }
        }
        
        if drawGrid { context.addPath(gridLines) }
        
        context.setStrokeColor(axisColor.withAlphaComponent(0.5).cgColor)
        context.setLineWidth(axisLineWidth / 2)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineLayer.frame = bounds
        markersLayer.frame = bounds
        
        if let points = linePoints {
            setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
            plotGraph(points)
        }
    }
    
    func setAxisRange(forPoints points: [CGPoint]) {
        guard !points.isEmpty else { return }
        
        let xs = points.map() { $0.x }
        let ys = points.map() { $0.y }
        
        xMax = ceil(xs.max()! / stepX) * stepX
        yMax = ceil(ys.max()! / stepY) * stepY
        xMin = 0
        yMin = 0
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(maxY))".size(withSystemFontSize: labelFontSize)
        
        let xOffset = xLabelSize.height + 2
        let yOffset = yLabelSize.width + 5
        
        let xScale = (bounds.width - yOffset - xLabelSize.width / 2 - 2)/(maxX - minX)
        let yScale = (bounds.height - xOffset - yLabelSize.height / 2 - 2)/(maxY - minY)
        
        chartTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: yOffset, ty: bounds.height - xOffset)
        
        setNeedsDisplay()
    }
    
    func plotGraph(_ points: [CGPoint]) {
        lineLayer.path = nil
        markersLayer.path = nil
        linePoints = nil
        
        guard !points.isEmpty else { return }
        
        linePoints = points
        
//        if self.chartTransform == nil { setAxisRange(forPoints: points) }
        
        setAxisRange(forPoints: points)
        
        let linePath = CGMutablePath()
        linePath.addLines(between: points, transform: chartTransform!)
        
        lineLayer.path = linePath
        
        markersLayer.path = circles(atPoints: points, withTransform: chartTransform!)
    }
    
    func circles(atPoints points: [CGPoint], withTransform t: CGAffineTransform) -> CGPath {
        
        let path = CGMutablePath()
        let radius = lineLayer.lineWidth * markersSize/2
        for i in points {
            let p = i.applying(t)
            let rect = CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)
            path.addEllipse(in: rect)
            
        }
        return path
    }
    
}
