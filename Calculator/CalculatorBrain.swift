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
    private var currentPrecedence = Int.max
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String,String) -> String, Int)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt, {"√(" + $0 + ")"}),
        "∛": Operation.unaryOperation(cbrt, {"∛(" + $0 + ")"}),
        "㏑" : Operation.unaryOperation(log, {"㏑(" + $0 + ")"}),
        "cos" : Operation.unaryOperation(cos, {"cos(" + $0 + ")"}),
        "x²" : Operation.unaryOperation({ pow($0,2) }, {"(" + $0 + ")²"}),
        "±" : Operation.unaryOperation({ -$0 }, {"-" + $0}),
        "x⁻¹": Operation.unaryOperation({1 / $0}, {"1/" + $0}),
        "×" : Operation.binaryOperation({ $0 * $1 },{ $0 + "*" + $1 }, 1),
        "÷" : Operation.binaryOperation({ $0 / $1 },{ $0 + "/" + $1 }, 1),
        "+" : Operation.binaryOperation({ $0 + $1 },{ $0 + "+" + $1 }, 0),
        "−" : Operation.binaryOperation({ $0 - $1 },{ $0 + "-" + $1 }, 0),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let constant = operations[symbol] {
            switch constant {
            case .constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .unaryOperation(let function, let functionDescription):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    descriptionAccumulator = functionDescription(descriptionAccumulator)
                }
            case .binaryOperation(let function, let descriptionFunction, let precedence):
                performPendingBinaryOperation()
                if currentPrecedence<precedence {
                    descriptionAccumulator = "(" + descriptionAccumulator + ")"
                }
                currentPrecedence = precedence
                pendingBinaryOperation = PendingBinaryOperation(function: function, descriptionFunction:descriptionFunction, firstOperand: accumulator!, descriptionFirstOperand: descriptionAccumulator)
            case .equals:
                performPendingBinaryOperation()
            }
        }
        
    }
    
    private mutating func performPendingBinaryOperation() {
        if (pendingBinaryOperation != nil && accumulator != nil) {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            descriptionAccumulator = pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionFirstOperand, descriptionAccumulator)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let descriptionFunction: (String,String) -> String
        let firstOperand: Double
        let descriptionFirstOperand: String
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        descriptionAccumulator = String(accumulator!)
    }
    
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var description: String? {
        get {
            if pendingBinaryOperation == nil {
                return descriptionAccumulator
            }
            else {
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionFirstOperand, (descriptionAccumulator != pendingBinaryOperation!.descriptionFirstOperand ?descriptionAccumulator : "")
                )
            }
            
        }
    }
    
    private var descriptionAccumulator = "0" {
        didSet {
            if pendingBinaryOperation == nil {
                currentPrecedence = Int.max
            }
        }
    }
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
}
