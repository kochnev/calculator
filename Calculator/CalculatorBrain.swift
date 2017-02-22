//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alexander Kochnev on 21.02.17.
//  Copyright © 2017 Alexander Kochnev. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var operations: Dictionary<String,Double> = [
        "π" : Double.pi,
        "e" : M_E
    ]
    mutating func performOperation(_ symbol: String) {
        if let constant = operations[symbol] {
            accumulator = constant
        }
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
