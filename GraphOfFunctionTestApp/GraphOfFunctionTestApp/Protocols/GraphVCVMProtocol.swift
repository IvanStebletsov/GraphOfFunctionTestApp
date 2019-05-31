//
//  GraphVCVMProtocol.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 01/06/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import UIKit

protocol GraphVCVMProtocol {
    
    func computePoints(for expression: String) -> [CGPoint]
    
}
