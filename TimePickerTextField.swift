//
//  TimePickerTextField.swift
//  FTN
//
//  Created by Marko Stajic on 5/9/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

class TimePickerTextField: UITextField {
    
    var datePickerView: UIDatePicker!
    var toolbarRightButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.returnKeyType = .next
        self.autocapitalizationType = .words
        
        self.backgroundColor = UIColor.white
        self.textColor = UIColor.dmsLightNavy
        self.font = UIFont(name: Font.GothamMedium, size: 17)
        self.tintColor = UIColor.dmsLightNavy
        self.textAlignment = .right
        
        //        self.rightViewMode = UITextFieldViewMode.always
        
        if let place = self.placeholder{
            self.attributedPlaceholder = NSAttributedString(string: place,
                                                            attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlueTwo, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 17)!])
        }
        
        datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        
        datePickerView.backgroundColor = UIColor.white
        datePickerView.layer.borderColor = UIColor.blue.cgColor
        datePickerView.datePickerMode = UIDatePickerMode.time
        datePickerView.subviews[0].subviews[0].subviews[0].subviews[0].isHidden = true
        
        
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
        
        datePickerView.addTarget(self, action: #selector(TimePickerTextField.dateChanged(_:)), for: UIControlEvents.valueChanged)
        inputView = datePickerView
    }
    
    func updatePlaceholder(_ placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlueTwo, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 17)!])
        
    }
    
    func rightButtonPressed(){
        endEditing(true)
    }
    
    func dateChanged(_ datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        self.text = dateFormatter.string(from: datePicker.date).lowercased()
    }
    
    
    //    override func textRect(forBounds bounds: CGRect) -> CGRect {
    //        return CGRect(x: bounds.origin.x + 15, y: bounds.origin.y + 8, width: bounds.size.width - 40, height: bounds.size.height - 16)
    //    }
    //
    //    override func editingRect(forBounds bounds: CGRect) -> CGRect {
    //        return self.textRect(forBounds: bounds)
    //    }
    //
    //    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    //        return CGRect(x: bounds.size.width - 30, y: bounds.size.height/2 - 10/2, width: 20, height: 11)
    //    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
}
