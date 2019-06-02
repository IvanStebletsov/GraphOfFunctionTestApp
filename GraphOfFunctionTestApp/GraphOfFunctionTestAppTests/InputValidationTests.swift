//
//  InputValidationTests.swift
//  GraphOfFunctionTestAppTests
//
//  Created by Ivan Stebletsov on 02/06/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import XCTest
@testable import GraphOfFunctionTestApp

class InputValidationTests: XCTestCase {
    
    let failCases = ["x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9", "0x", "1x", "2x", "3x", "4x", "5x", "6x", "7x", "8x", "9x", ".", "-+", "+-", "-*", "*-", "--", "++", "**", "=", "  ", "xx", ")x", "x(", "()", "–"]
    
    let failExpressions = ["x-", "1+", "4*", "7*", "x *", "(3 * (x +", "-x+", "-+-"]
    
    var inputValidator: InputValidator!
    
    override func setUp() {
        inputValidator = InputValidator()
    }
    
    override func tearDown() {
        inputValidator = nil
    }
    
    func testInputCorrectionLogic() {
        for each in failCases {
            let correctedInput = each.correctInput()
            XCTAssertEqual(correctedInput, "", "This expression must be empty")
        }
    }
    
    func testInputValidation() {
        for each in failExpressions {
            let validationResult = inputValidator.isValid(this: each.correctInput())
            XCTAssertFalse(validationResult.0, "This expression must be false")
            XCTAssertNotNil(validationResult.1, "This expression must be nil")
        }
    }
    
}
