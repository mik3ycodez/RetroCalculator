//
//  ViewController.swift
//  RetroCalculator
//
//  Created by cbeuser on 4/30/17.
//  Copyright © 2017 CBE User. All rights reserved.
//

import UIKit
import AVFoundation

class CalculatorVC: UIViewController {
    
    var btnSound: AVAudioPlayer!
    @IBOutlet weak var outputLbl: UILabel!
    
    //Storage Arrays
    var calcStringNumberEntries = [String?]() //Stores user entries to allow for textView display
    var calcStringOperatorsArray = [String?]() //Stores operators for math operation
    var calcDoubleNumbersArray = [Double?]() //Stores the double value of the string array
    
    //Variables
    var i = 0 //Array counter
    var p = 0 //EqualsPressed Array Counter
    var tempValue: Double? //Holding value in math calculation to be converted to finalResult
    var finalResult = "" //Final calculation to be used in label
    var equalsPressed = false
    var arrayNonNullValue = 0
    var arraysAreEven = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    @IBAction func onClearPressed(_ sender: UIButton) {
        playSound()
        calcStringNumberEntries = []
        calcStringOperatorsArray = []
        calcDoubleNumbersArray = []
        i = 0
        p = 0
        tempValue = nil
        finalResult = ""
        equalsPressed = false
        arrayNonNullValue = 0
        arraysAreEven = false
        outputLbl.text = "0.0"
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        playSound()
        
        if equalsPressed {
            calcStringNumberEntries[i] = "\(sender.tag)"
            equalsPressed = false
        } else {
            if calcStringNumberEntries[i] != nil {
                calcStringNumberEntries[i] = "\(sender.tag)"
            } else {
                calcStringNumberEntries[i] = calcStringNumberEntries[i]! + "\(sender.tag)"
            }
        }
        outputLbl.text = calcStringNumberEntries[i]
        
    }
    
    @IBAction func operatorPressed(_ sender: UIButton) {
        playSound()
        
        calculateArrayNonNil()
        if !arraysAreEven {
            calcStringOperatorsArray[i] = "\(String(describing: sender.title(for: .normal)))"
            i = i + 1
            equalsPressed = false
        }
    }
    
    @IBAction func decimalPressed(_ sender: UIButton) {
        playSound()
        
        var testArrayElementForDecimal = ""
        testArrayElementForDecimal = calcStringNumberEntries[i]!
        
        if calcStringNumberEntries[i] != nil { calcStringNumberEntries[i] = "0." }
        else if !testArrayElementForDecimal.contains(".") { calcStringNumberEntries[i] = "0." }
        else if equalsPressed { calcStringNumberEntries[i] = "0." }
        else { calcStringNumberEntries[i] = calcStringNumberEntries[i]! + "." }
        equalsPressed = false
        outputLbl.text = calcStringNumberEntries[i]
    }
    
    @IBAction func onEqualPressed(_ sender: UIButton) {
        playSound()
        
        i = 0
        p = 0
        calcDoubleNumbersArray = calcStringNumberEntries.map{ NSString(string: $0!).doubleValue }
        
        if calcDoubleNumbersArray[i] != nil { tempValue = calcDoubleNumbersArray[i] }

        if tempValue != nil {
            
            for _ in calcStringOperatorsArray {
                p = p + 1
                if (p == calcStringOperatorsArray.count) {
                    break
                }
                if calcStringOperatorsArray[i] != nil {
                    switch calcStringOperatorsArray[i] {
                    case "/"?:
                        if calcDoubleNumbersArray[p] == 0 {
                            //Learn how to push an alert with message "Divide By Zero"
                            outputLbl.text = "Div by 0"
                        } else {
                            tempValue = tempValue! / calcDoubleNumbersArray[p]!
                            finalResult = String(format: "%.03", tempValue!)
                            outputLbl.text = finalResult
                        }
                        break
                    case "*"?:
                        tempValue = tempValue! * calcDoubleNumbersArray[p]!
                        finalResult = String(format: "%.03", tempValue!)
                        outputLbl.text = finalResult
                        break
                    case "-"?:
                        tempValue = tempValue! - calcDoubleNumbersArray[p]!
                        finalResult = String(format: "%.03", tempValue!)
                        outputLbl.text = finalResult
                        break
                    case "+"?:
                        tempValue = tempValue! + calcDoubleNumbersArray[p]!
                        finalResult = String(format: "%.03", tempValue!)
                        outputLbl.text = finalResult
                        break
                    default:
                        break
                    }
                }
            }
        }
        
        calcStringNumberEntries = []
        calcStringOperatorsArray = []
        calcDoubleNumbersArray = []
        i = 0
        p = 0
        tempValue = nil
        finalResult = ""
        equalsPressed = false
        arrayNonNullValue = 0
        arraysAreEven = false
        outputLbl.text = "0.0"
    }
    
    @discardableResult func calculateArrayNonNil() -> Bool {
        arrayNonNullValue = 0
        var stringNumberHolder = 0
        var stringOperatorHolder = 0
        
        stringNumberHolder = calcStringNumberEntries.count
        stringOperatorHolder = calcStringOperatorsArray.count
        arrayNonNullValue = stringNumberHolder + stringOperatorHolder
        arraysAreEven = arrayNonNullValue % 2 == 0
        return arraysAreEven
    }
}

/*

 *** JAVA Code from working functional calculator that I built ***

 //Storage Arrays
 String[] calcStringNumberEntries = new String[100]; //Stores user entries to allow for textView display
 String[] calcStringOperatorsArray = new String[100]; //Stores operators to initialize math of ints
 Double[] calcNumbersArray = new Double[100]; //Stores the int value of the string array
 
 //Variables
 int i = 0; //Array counter
 Double tempValue = 0.0d; //Final calculation total after math is completed
 boolean equalsPressed = false;
 int arrayNonNullValue = 0;
 boolean arraysAreEven = false;
 
 @Override
 protected void onCreate(Bundle savedInstanceState) {
 super.onCreate(savedInstanceState);
 setContentView(R.layout.activity_main);
 
 final DecimalFormat df = new DecimalFormat("#.##");
 df.setRoundingMode(RoundingMode.CEILING);
 
 mClearButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 calcStringNumberEntries = null;
 calcStringNumberEntries = new String[100];
 calcStringOperatorsArray = null;
 calcStringOperatorsArray = new String[100];
 calcNumbersArray = null;
 calcNumbersArray = new Double[100];
 myTextView.setText("0");
 i = 0;
 }
 });
 
 
 mSevenButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "7";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "7";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "7";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mEightButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "8";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "8";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "8";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mNineButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "9";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "9";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "9";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mDivideButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 calculateArrayNonNull();
 if (!arraysAreEven) {
 calcStringOperatorsArray[i] = "/";
 i++;
 equalsPressed = false;
 }
 }
 });
 
 
 mFourButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "4";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "4";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "4";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mFiveButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "5";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "5";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "5";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mSixButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "6";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "6";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "6";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mMultiplyButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 calculateArrayNonNull();
 if (!arraysAreEven) {
 calcStringOperatorsArray[i] = "*";
 i++;
 equalsPressed = false;
 }
 }
 });
 
 
 mOneButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "1";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "1";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "1";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mTwoButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "2";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "2";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "2";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mThreeButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "3";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "3";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "3";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mSubtractButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 calculateArrayNonNull();
 if (!arraysAreEven) {
 calcStringOperatorsArray[i] = "-";
 i++;
 equalsPressed = false;
 }
 }
 });
 
 
 mZeroButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 if (equalsPressed) {
 calcStringNumberEntries[i] = "0";
 equalsPressed = false;
 } else {
 if (calcStringNumberEntries[i] == null) {
 calcStringNumberEntries[i] = "0";
 } else {
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + "0";
 }
 }
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mDecimalButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 
 //Boolean variable that checks index if it contains a decimal
 //If false add "."
 //If true ignore
 System.out.println("Start boolean expression");
 String testArrayElement = calcStringNumberEntries[i];
 //boolean returnValue = testArrayElement.contains(cs1);
 System.out.println("Start decimal if statement");
 if (calcStringNumberEntries[i] == null) {
 System.out.println("csne[i] == null");
 calcStringNumberEntries[i] = "0.";
 } else if (testArrayElement.indexOf(".") != -1) {
 System.out.println("csne[i] != null and !returnValue");
 calcStringNumberEntries[i] = "0.";
 } else if (equalsPressed) {
 calcStringNumberEntries[i] = "0.";
 } else {
 System.out.println("csne[i] != null and returnValue");
 calcStringNumberEntries[i] = calcStringNumberEntries[i] + ".";
 }
 equalsPressed = false;
 myTextView.setText(calcStringNumberEntries[i].toString());
 }
 });
 
 
 mAdditionButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 calculateArrayNonNull();
 if (!arraysAreEven) {
 calcStringOperatorsArray[i] = "+";
 i++;
 equalsPressed = false;
 }
 }
 });
 
 
 mEqualsButton.setOnClickListener(new View.OnClickListener() {
 public void onClick(View v) {
 i = 0;
 System.out.println("Start writing string user entries.");
 for (int j=0; j<calcStringNumberEntries.length;j++) {
 if (calcStringNumberEntries[j] != null) {
 System.out.println(calcStringNumberEntries[j]);
 }
 }
 System.out.println("Finished writing string user entries.");
 
 
 System.out.println("Start writing string operators.");
 for (int k=0; k<calcStringOperatorsArray.length; k++) {
 if (calcStringOperatorsArray[k] != null) {
 System.out.println(calcStringOperatorsArray[k]);
 }
 }
 System.out.println("Finished writing string operators.");
 
 System.out.println("Start writing int number entries.");
 for (int n=0; n < calcNumbersArray.length; n++) {
 if (calcNumbersArray[n] != null) {
 System.out.println(calcNumbersArray[n]);
 }
 }
 System.out.println("Finished writing int number entries.");
 
 System.out.println("Start copying string numbers to int numbers.");
 for (int l = 0; l < calcStringNumberEntries.length; l++) {
 if (calcStringNumberEntries[l] != null) {
 calcNumbersArray[l] = Double.parseDouble(calcStringNumberEntries[l]);
 }
 }
 System.out.println("The arrays copied successfully.");
 
 System.out.println("Start writing int number entries.");
 for (int m=0; m < calcNumbersArray.length; m++) {
 if (calcNumbersArray[m] != null) {
 System.out.println(calcNumbersArray[m]);
 }
 }
 System.out.println("Finished writing int number entries.");
 
 
 System.out.println("Starting math computation.");
 if (calcNumbersArray[0] != null) {
 tempValue = calcNumbersArray[0];
 }
 System.out.println(tempValue);
 String finalResult;
 
 
 if (tempValue != null) {
 System.out.println("Starting for math statement.");
 for (i = 0; i < calcStringOperatorsArray.length; i++) {
 
 int p = i + 1;
 if (p == 100) {
 break;
 }
 
 if (calcStringOperatorsArray[i] != null) {
 switch (calcStringOperatorsArray[i]) {
 case "/":
 if (calcNumbersArray[p] == 0) {
 myTextView.setText(getString(R.string.divide_error_msg));
 } else {
 tempValue = tempValue / calcNumbersArray[p];
 finalResult = String.valueOf(df.format(tempValue));
 myTextView.setText(finalResult);
 System.out.println(finalResult);
 }
 break;
 case "*":
 tempValue = tempValue * calcNumbersArray[p];
 finalResult = String.valueOf(df.format(tempValue));
 myTextView.setText(finalResult);
 System.out.println(finalResult);
 break;
 case "-":
 tempValue = tempValue - calcNumbersArray[p];
 finalResult = String.valueOf(df.format(tempValue));
 myTextView.setText(finalResult);
 System.out.println(finalResult);
 break;
 case "+":
 tempValue = tempValue + calcNumbersArray[p];
 finalResult = String.valueOf(df.format(tempValue));
 myTextView.setText(finalResult);
 break;
 default:
 break;
 }
 }
 }
 System.out.println("Ending for math statement");
 }
 
 equalsPressed = true;
 if (calcStringNumberEntries[i] != null) {
 System.out.println(df.format(tempValue));
 }
 System.out.println("Finished math computation.");
 
 calcStringNumberEntries = null;
 calcStringNumberEntries = new String[100];
 calcStringOperatorsArray = null;
 calcStringOperatorsArray = new String[100];
 calcNumbersArray = null;
 calcNumbersArray = new Double[100];
 i = 0;
 if (calcStringNumberEntries != null) {
 calcStringNumberEntries[i] = String.valueOf(df.format(tempValue));
 System.out.println(calcStringNumberEntries[i]);
 }
 }
 });
 }
 
 boolean calculateArrayNonNull() {
 arrayNonNullValue = 0;
 int stringNumberHolder = 0;
 int stringOperatorHolder = 0;
 for (int c = 0; c < calcStringNumberEntries.length; c++) {
 if (calcStringNumberEntries[c] != null) {
 stringNumberHolder = stringNumberHolder + 1;
 }
 }
 for (int d = 0; d < calcStringOperatorsArray.length; d++) {
 if (calcStringOperatorsArray[d] != null) {
 stringOperatorHolder = stringOperatorHolder + 1;
 }
 }
 
 arrayNonNullValue = stringNumberHolder + stringOperatorHolder;
 arraysAreEven = arrayNonNullValue % 2 == 0;
 return arraysAreEven;
 }
 
 /*int formatDecimalFromUserInput() {
 String myTextView.getText();
 double d= Double.parseDouble(myTextView.getText());
 String text = Double.toString(Math.abs(d));
 int integerPlaces = text.indexOf('.');
 int decimalPlaces = text.length() - integerPlaces - 1;
 return decimalPlaces;
 }*/
 }
 
 */


/*
 
 *** Original Code from DevSlopes Mark Price lesson ***
 
 //    enum Operation: String {
 //        case Divide = "/"
 //        case Multiply = "*"
 //        case Subtract = "-"
 //        case Add = "+"
 //        case Empty = "Empty"
 //    }
 
 
 //    var currentOperation = Operation.Empty
 //    var leftValStr = ""
 //    var rightValStr = ""
 //    var result = ""
 //    var runningNumber = ""
 
 /*@IBAction func numberPressed(_ sender: UIButton) {
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
 
 @IBAction func onClearPressed(_ sender: UIButton) {
 playSound()
 currentOperation = Operation.Empty
 leftValStr = ""
 rightValStr = ""
 result = ""
 runningNumber = ""
 outputLbl.text = "0.0"
 }*/
 
 /*func processOperation(operation: Operation) {
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
 }*/
 
 */

