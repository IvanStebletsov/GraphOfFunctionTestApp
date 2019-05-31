//
//  GraphVCVM.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 31/05/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import UIKit

class GraphVCVM: GraphVCVMProtocol {
    
    // MARK: - GraphVCVMProtocol methods
    func computePoints(for expression: String) -> [CGPoint] {
        var chartPoints = [CGPoint]()
        for x in 0...50 {
            guard let y = calculateString(expression: expression, with: Double(x)) else { break }
            chartPoints.append(CGPoint(x: Double(x), y: y))
        }
        return chartPoints.filter { $0.y >= 0 && $0.y <= 2000 && $0.x >= 0 }
    }
    
    func calculateString(expression string: String, with argument: Double) -> Double? {
        let stringWithArguments = string.replacingOccurrences(of: "x", with: String(argument), options: .literal, range: nil)
        
        let expression = NSExpression(format: stringWithArguments)
        
        guard let result = expression.expressionValue(with: nil, context: nil) as? Double else { return nil }
        
        return result
    }
    
}
