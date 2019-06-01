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
        
        let xAxisPoints = [CGPoint(x: xMin, y: 0), CGPoint(x: xMax, y: 0)] // Положение оси X
        let yAxisPoints = [CGPoint(x: 0, y: yMin), CGPoint(x: 0, y: yMax)] // Положение оси Y
        
        axesLines.addLines(between: xAxisPoints, transform: transform)
        axesLines.addLines(between: yAxisPoints, transform: transform)
        
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(axisLineWidth)
        context.addPath(axesLines)
        context.strokePath()
        
        drawGrid(in: context, using: transform)
        context.strokePath()
        
        context.restoreGState()
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
        
        let xPoints = points.map() { $0.x }
        let yPoints = points.map() { $0.y }
        
        switch Int(yPoints.max()!) {
        case 0...25:
            stepY = 1
        case 26...50:
            stepY = 5
        case 51...100:
            stepY = 10
        case 101...200:
            stepY = 20
        case 201...300:
            stepY = 30
        case 301...400:
            stepY = 40
        case 401...500:
            stepY = 50
        case 501...600:
            stepY = 60
        default:
            stepY = 100
        }
        
        if Set(yPoints).count == 1 && yPoints.first != 0 {
            xMax = 50
            yMax = ceil(yPoints.max()! / stepY) * stepY * 2
            xMin = 0
            yMin = 0
        } else if Int(yPoints.max()!) > 100 {
            xMax = ceil(xPoints.max()! / stepX) * stepX
            yMax = ceil(yPoints.max()! / stepY) * stepY
            xMin = 0
            yMin = 0
        } else {
            xMax = 50
            yMax = 2000
            xMin = 0
            yMin = 0
            stepY = 100
        }
        
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
        
        setAxisRange(forPoints: points)
        
        let linePath = CGMutablePath()
        linePath.addLines(between: points, transform: chartTransform!)
        
        lineLayer.path = linePath
        
        markersLayer.path = circles(atPoints: points, with: chartTransform!)
    }
    
    func circles(atPoints points: [CGPoint], with transform: CGAffineTransform) -> CGPath {
        let path = CGMutablePath()
        let radius = lineLayer.lineWidth * markersSize / 2
        for i in points {
            let p = i.applying(transform)
            let rect = CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)
            path.addEllipse(in: rect)
        }
        return path
    }
    
}
