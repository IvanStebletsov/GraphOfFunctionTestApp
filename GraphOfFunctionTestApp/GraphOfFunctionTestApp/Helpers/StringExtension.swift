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
    
}
