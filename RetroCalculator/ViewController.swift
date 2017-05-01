//
//  ViewController.swift
//  RetroCalculator
//
//  Created by cbeuser on 4/30/17.
//  Copyright © 2017 CBE User. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var btnSound: AVAudioPlayer!
    @IBOutlet weak var outputLbl: UILabel!
    
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    

    var currentOperation = Operation.Empty
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    var runningNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        //let soundURL = URL(fileURLWithPath: path!)
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = "0.0"
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
        
    }
    
    @IBAction func onDividePressed(_ sender: UIButton) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: UIButton) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(_ sender: UIButton) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(_ sender: UIButton) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(_ sender: UIButton) {
        processOperation(operation: currentOperation)
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            //A user selected an operator, but then selected another operator without first entering a number.
            
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            currentOperation = operation
        } else {
            //This is the first time an operator has been pressed.
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    
}
















