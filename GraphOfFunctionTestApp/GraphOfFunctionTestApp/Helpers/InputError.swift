//
//  InputError.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 01/06/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import Foundation

enum InputError: String {
    
    case missingParenthesis
    case missingOperand
    case missingOperator
    case missingX
    
    var reason: String {
        switch self {
        case .missingParenthesis:
            return "Нехватает скобки ()"
        case .missingOperand:
            return "В выражении нехватает одного операнда (x, 0-9)"
        case .missingOperator:
            return "В выражении нехватает математического оператора (+, -, *)"
        case .missingX:
            return "В выражении нехватает переменной (x)"
        }
    }
    
}
