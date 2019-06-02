//
//  InputError.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 01/06/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import Foundation

enum InputError: Error {
    
    case missingParenthesis
    case missingOperand
    case complexError
    case negativeResult
    
    var reason: String {
        switch self {
        case .missingParenthesis:
            return "Нехватает скобки ()"
        case .missingOperand:
            return "В выражении не хватает операнда (x, 0-9)"
        case .complexError:
            return "Выражение введено некорректно.\nИспользуйте числа (0-9), математические операторы (+, -, *) и переменную (x)\nНапример: 3 * (2 + x)"
        case .negativeResult:
            return "Введенное выражение дает отрицательный результат"
        }
    }
    
}
