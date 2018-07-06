//
//  HeightPickerField.swift
//  FTN
//
//  Created by Marko Stajic on 1/25/17.
//  Copyright © 2017 DMS. All rights reserved.
//
typealias ImperialHeightType = (feets: [UInt], inches: [UInt])
public typealias ImperialHeight = (feets: UInt, inches: UInt)

protocol HeightPickerDelegate : class  {
    func returnHeight(height: ImperialHeight)
}

import UIKit

class HeightPickerField: PlaceholderTextField {
    
    var pickerView: UIPickerView!
    var toolbarRightButton: UIBarButtonItem!
    
    weak var pickerDelegate:HeightPickerDelegate?
    var items: ImperialHeightType = ImperialHeightType(feets: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], inches: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]) {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    var rightButtonTitle:String? {
        set {
            toolbarRightButton.title = newValue
        }
        get {
            return toolbarRightButton.title
        }
    }
    override var text: String! {
        set {
            super.text = newValue
        }
        get {
            return super.text
        }
    }
    
    var selectedFeet : UInt?
    var selectedInch : UInt?
    
    func initialHeight(feets: Int, inches: Int){
        self.pickerView.selectRow(feets, inComponent: 0, animated: false)
        self.pickerView.selectRow(inches, inComponent: 1, animated: false)
        self.selectedFeet = UInt(feets)
        self.selectedInch = UInt(inches)
    }
    
    func updateText(){
        if let selFeet = selectedFeet {
            if let selInch = selectedInch {
                self.text = String(selFeet) + " ft" + "  " + String(selInch) + " in"
                pickerDelegate?.returnHeight(height: ImperialHeight(feets: selFeet, inches: selInch))
            }else{
                self.text = String(selFeet) + " ft" + "  " + "0 in"
                pickerDelegate?.returnHeight(height: ImperialHeight(feets: selFeet, inches: 0))

            }
        }else if let selInch = selectedInch {
            self.text = "0 ft" + "  " + String(selInch) + " in"
            pickerDelegate?.returnHeight(height: ImperialHeight(feets: 0, inches: selInch))

        }else{
            self.text = "0 ft" + "  " + "0 in"
            pickerDelegate?.returnHeight(height: ImperialHeight(feets: 0, inches: 0))

        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        tintColor = UIColor.clear
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 166))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let toolbarRightButton = UIBarButtonItem(title: "Done".uppercased(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(resignFirstResponder))
        toolbarRightButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: Font.GothamBold, size: 17.0)!], for: UIControlState.normal)
        toolbar.barTintColor = UIColor.dmsOffBlue
        toolbar.isTranslucent = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignFirstResponder))
        toolbar.addGestureRecognizer(tap)
        
        toolbarRightButton.tintColor = UIColor.white
        toolbar.items = [flexibleSpace, toolbarRightButton, flexibleSpace]
        inputAccessoryView = toolbar
        inputView = pickerView
    }
    
    func rightButtonPressed(sender: UIBarButtonItem) {
        print("Done pressed")
        self.resignFirstResponder()
    }
    var greaterHeight = false{
        didSet{
            pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 166))
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = UIColor.dmsMango
            inputView = pickerView
        }
    }
    
    //    func textForRow(row: Int) -> String {
    //        if row == 0 && hasFirstEmpty {
    //            return ""
    //        }
    //        return items?[indexForItemInRow(row: row)] ?? ""
    //    }
    
    
    // MARK: Picker view delegate
    //    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    //        return 1
    //    }
    //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    //        return (items?.count ?? 0) + firstItemIndex
    //    }
    
    //    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    //        return textForRow(row)
    //    }
    
    
    //    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    //                return 60
    //    }
    //
    //
    //    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
    //        let pickerLabelText = LabelPicker()
    //        if greaterHeight {
    //            pickerLabelText.frame = CGRectMake(0,0, UIScreen.mainScreen().bounds.width, 45)
    //            pickerLabelText.numberOfLines = 2
    //        }else{
    //            pickerLabelText.frame = CGRectMake(0,0, UIScreen.mainScreen().bounds.width, 24)
    //        }
    //
    //        pickerLabelText.sizeToFit()
    //        pickerLabelText.text = textForRow(row)
    //        pickerLabelText.textAlignment = NSTextAlignment.Center
    //        return pickerLabelText
    //    }
    //    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //        text = textForRow(row)
    //        sendActionsForControlEvents(.AllEditingEvents)
    //        if row > 0 {
    //            pickerDelegate?.pickerField?(self, didSelectRowAtIndex: (indexForItemInRow(row)))
    //        }
    //    }
}

extension HeightPickerField : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return items.feets.count
        default:
            return items.inches.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return String(items.feets[row]) + " ft"
        default:
            return String(items.inches[row]) + " in"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedFeet = items.feets[row]
        default:
            selectedInch = items.inches[row]
        }
        updateText()
    }
}
