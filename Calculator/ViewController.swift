//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Kochnev on 20.02.17.
//  Copyright © 2017 Alexander Kochnev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var history: UILabel!
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInMiddleOfTyping {
            let currentTextInDisplay = display.text!
            display.text = currentTextInDisplay + digit
        }
        else {
            display.text = digit
            userIsInMiddleOfTyping = true
        }
        
    }
    
    
    
    @IBAction func touchDot(_ sender: UIButton) {
        if userIsInMiddleOfTyping {
            let currentTextInDisplay = display.text!
            if !currentTextInDisplay.contains(".") {
                display.text = currentTextInDisplay + "."
            }
        }
        else
        {
             display.text = "0."
             userIsInMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        if let resultDescription = brain.description{
            history.text =  (brain.resultIsPending) ? resultDescription + "..." : resultDescription + "="
            
        }
    }
    
    
    
}

