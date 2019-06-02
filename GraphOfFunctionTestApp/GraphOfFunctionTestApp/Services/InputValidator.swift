//
//  InputValidator.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 02/06/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import Foundation

class InputValidator {
    
    let allowedCharacters = "0123456789x()"
    let mathOperatorsString = "+-*"
    let mathOperatorsCharacterSet = CharacterSet(charactersIn: "+-*")
    
    func isValid(this expression: String) -> (Bool, InputError?) {

        if expression.filter({ $0 == "(" }).count != expression.filter({ $0 == ")" }).count {
            return (false, InputError.missingParenthesis)
        }
        
        if expression.count >= 2 && mathOperatorsString.contains(expression.last!) {
            return (false, InputError.missingOperand)
        }
        
        if expression.count >= 3 && expression.filter({ allowedCharacters.contains($0) }).count < expression.count / 2 {
            return (false, InputError.complexError)
        }
        
        if expression.count == 1 && (expression.rangeOfCharacter(from: mathOperatorsCharacterSet) != nil) {
            return (false, InputError.missingOperand)
        }
        
        return (true, nil)
    }
    
}
