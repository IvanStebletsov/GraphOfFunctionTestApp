//
//  GraphVCVMTests.swift
//  GraphOfFunctionTestAppTests
//
//  Created by Ivan Stebletsov on 02/06/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import XCTest
@testable import GraphOfFunctionTestApp

class GraphVCVMTests: XCTestCase {
    
    var viewModel: GraphVCVMProtocol!
    
    override func setUp() {
        viewModel = GraphVCVM()
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func testCanGraphVCVMComputePointsFromValidStringExpression() {
        let validExpression = "x * x"
        
        let points = viewModel.computePoints(for: validExpression)
        
        XCTAssertNotEqual(points.count, 0, "GraphVCVM can not compute points from valid string expression")
    }
}
