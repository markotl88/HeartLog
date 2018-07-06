//
//  DurationPickerField.swift
//  FTN
//
//  Created by Marko Stajic on 2/1/17.
//  Copyright © 2017 DMS. All rights reserved.
//
typealias Duration = (hours: UInt, minutes: UInt)
typealias DurationType = (hours: [UInt], minutes: [UInt])

protocol DurationPickerDelegate : class  {
    func returnTime(totalMinutes: Int)
}

import UIKit

class DurationPickerField: PlaceholderTextField {
    
    var pickerView: UIPickerView!
    var toolbarRightButton: UIBarButtonItem!
    
    weak var pickerDelegate:DurationPickerDelegate?
    var items: DurationType = DurationType(hours: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], minutes: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]) {
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
    
    var selectedHours : UInt?
    var selectedMinutes : UInt?
    
    func initialValues(hours: Int, minutes: Int){
        self.pickerView.selectRow(hours, inComponent: 0, animated: false)
        self.pickerView.selectRow(minutes, inComponent: 1, animated: false)
        self.selectedHours = UInt(hours)
        self.selectedMinutes = UInt(minutes)
    }
    
    func updateText(){
        if let selHour = selectedHours {
            if let selMin = selectedMinutes {
                if selHour == 1 {
                    self.text = String(selHour) + " hour" + "  " + String(selMin) + " min"
                }else{
                    self.text = String(selHour) + " hours" + "  " + String(selMin) + " min"
                }
                let totalMinutes = Int(selHour)*60+Int(selMin)
                pickerDelegate?.returnTime(totalMinutes: totalMinutes)
            }else{
                if selHour == 1 {
                    self.text = String(selHour) + " hour" + "  " + "0 min"
                }else{
                    self.text = String(selHour) + " hours" + "  " + "0 min"
                }
                let totalMinutes = Int(selHour)*60
                pickerDelegate?.returnTime(totalMinutes: totalMinutes)
            }
        }else if let selMin = selectedMinutes {
            self.text = "0 hours" + "  " + String(selMin) + " min"
            let totalMinutes = Int(selMin)
            pickerDelegate?.returnTime(totalMinutes: totalMinutes)
            
        }else{
            self.text = "0 hours" + "  " + "0 min"
            pickerDelegate?.returnTime(totalMinutes: 0)
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

extension DurationPickerField : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return items.hours.count
        default:
            return items.minutes.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            if items.hours[row] == 1 {
                return String(items.hours[row]) + " hour"
            }else{
                return String(items.hours[row]) + " hours"
            }
        default:
            return String(items.minutes[row]) + " min"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedHours = items.hours[row]
        default:
            selectedMinutes = items.minutes[row]
        }
        updateText()
    }
}
