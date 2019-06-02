//
//  StringExtension.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 30/05/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import UIKit

extension String {
    
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: pointSize)])
    }
    
    func correctInput() -> String {
        var correctInput = self.lowercased()
        let allowedCharacters = CharacterSet(charactersIn: "0123456789()+-*x ").inverted
        correctInput = correctInput.trimmingCharacters(in: allowedCharacters)
        
        let edgeCases = ["x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9", "0x", "1x", "2x", "3x", "4x", "5x", "6x", "7x", "8x", "9x", ".", "-+", "+-", "-*", "*-", "--", "++", "**", "=", "  ", "xx", ")x", "x(", "()", "–"]
        
        for errorCase in edgeCases {
            if correctInput.contains(errorCase) {
                correctInput = correctInput.trimmingCharacters(in: allowedCharacters).replacingOccurrences(of: errorCase, with: "")
            }
        }
        
        if correctInput.first == "+" || correctInput.first == "*" { correctInput.removeFirst() }

        return correctInput
    }
    
    func separateWithSpaces() -> String {
        var separatedString = ""
        for char in self.replacingOccurrences(of: " ", with: "") {
            separatedString += "\(char) "
        }
        return String(separatedString.dropLast())
    }
    
}
