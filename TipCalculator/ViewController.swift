//
//  ViewController.swift
//  TipCalculator
//
//  Created by Fiona Miao on 2/25/18.
//  Copyright © 2018 Fiona Miao. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var PreTaxAmountField: UITextField!
    @IBOutlet weak var taxAmountField: UITextField!
    @IBOutlet weak var postTaxAmount: UILabel!
    @IBOutlet weak var tipsAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tip15Button: UIButton!
    @IBOutlet weak var tip18Button: UIButton!
    @IBOutlet weak var tip20Button: UIButton!
    var selectedTipPerc = 0.15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--- add UIToolBar on keyboard and Done button on UIToolBar ---//
        self.addDoneButtonOnNumpad(textField:PreTaxAmountField)
        self.addDoneButtonOnNumpad(textField:taxAmountField)

        // Handle the text field’s user input through delegate callbacks.
        PreTaxAmountField.delegate = self
        taxAmountField.delegate = self
        updateTipsButtonState()
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keypadToolbar.items=[
             UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: textField, action: #selector(UITextField.resignFirstResponder))
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        textField.inputAccessoryView = keypadToolbar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        if (textField == self.PreTaxAmountField) {
            self.taxAmountField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        tip15Button.isEnabled = false
        tip18Button.isEnabled = false
        tip20Button.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTipsButtonState()
        let preTaxAmount = PreTaxAmountField.text?.floatValue
        let taxAmount = taxAmountField.text?.floatValue
        let afterTaxAmount = preTaxAmount! + taxAmount!
        if checkBothTextFieldHasInput() {
            postTaxAmount.text = "Post-Tax: " + String(format: "%.2f", afterTaxAmount)
            editButtonColor()
            calculateAndPrintResult()
        }
        
    }
    
    //MARK: Actions
    
    @IBAction func ClearAboveInputs(_ sender: Any) {
        PreTaxAmountField.text = nil
        taxAmountField.text = nil
        postTaxAmount.text = "Post-Tax: "
        tipsAmountLabel.text = "Tips: "
        totalAmountLabel.text = "Total: "
        updateTipsButtonState()
        
    }
    
    @IBAction func set15Tips(_ sender: UIButton) {
        selectedTipPerc = 0.15
        editButtonColor()
        calculateAndPrintResult()
        
    }
    @IBAction func set18Tips(_ sender: UIButton) {
        selectedTipPerc = 0.18
        editButtonColor()
        calculateAndPrintResult()
    }
    @IBAction func set20Tips(_ sender: UIButton) {
        selectedTipPerc = 0.20
        editButtonColor()
        calculateAndPrintResult()
    }
    
    //MARK: Private Methods
    private func updateTipsButtonState() {
        // Disable the Save button if the text field is empty.
        tip15Button.isEnabled = checkBothTextFieldHasInput()
        tip18Button.isEnabled = checkBothTextFieldHasInput()
        tip20Button.isEnabled = checkBothTextFieldHasInput()
    }
    
    private func checkBothTextFieldHasInput() -> Bool {
        let text1 = PreTaxAmountField.text ?? ""
        let text2 = taxAmountField.text ?? ""
        let result = !text1.isEmpty && !text2.isEmpty
        return result
    }
    
    private func editButtonColor() {
        let button = [tip15Button, tip18Button,tip20Button]
        let tips = [0.15, 0.18, 0.20]
        for i in 0..<3 {
            if selectedTipPerc == tips[i] {
                button[i]?.setTitleColor(UIColor .red, for: UIControlState.normal)
            }
            else {
                button[i]?.setTitleColor(UIColor .blue, for: UIControlState.normal)
            }
        }
    }
    
    func calculateTips(tipP: Float) -> (tipsAmount: Float, totalAmount: Float) {
        let preTaxAmount = PreTaxAmountField.text?.floatValue
        let taxAmount = taxAmountField.text?.floatValue
        let tipsAmount = preTaxAmount! * tipP
        let totalAmount = preTaxAmount! + taxAmount! + tipsAmount
        return (tipsAmount, totalAmount)
    }
    
    func printResult(tips: Float, total: Float) {
        tipsAmountLabel.text = "Tips: " + String(format: "%.2f", tips)
        totalAmountLabel.text! = "Total: " + String(format: "%.2f", total)
    }
    
    func calculateAndPrintResult() {
        let (tipsAmount, totalAmount) = calculateTips(tipP: Float(selectedTipPerc))
        printResult(tips: tipsAmount, total: totalAmount)
    }
    
    
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

