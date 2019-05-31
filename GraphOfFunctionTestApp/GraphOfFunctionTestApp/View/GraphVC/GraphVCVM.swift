//
//  GraphVCVM.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 31/05/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import UIKit

class GraphVCVM {
    
    // MARK: - Properties
    
    
    // MARK: - Initialization
    
    // MARK: - GraphVCVMProtocol methods
    func computePoints(for expression: (Double) -> Double) -> [CGPoint] {
        var chartPoints = [CGPoint]()
        for x in 0...100 {
            let y = expression(Double(x))
            chartPoints.append(CGPoint(x: Double(x), y: y))
        }
        return chartPoints
    }
    
}
