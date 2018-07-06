//
//  ManualResultCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/15/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

protocol ManuaEntryBloodPressureDelegate: class {
    func textFieldCheckPassed(_ passed: Bool, systolic: String?, diastolic: String?, hearbeat: String?, date: String?, time: String?)
}

class ManualResultCell: UITableViewCell {
    
    @IBOutlet var borderLines: [UIView]!
    
    @IBOutlet weak var dateLabel: UserAttributeLabel!
    @IBOutlet weak var timeLabel: UserAttributeLabel!
    
    @IBOutlet weak var systolicLabel: UserAttributeLabel!
    @IBOutlet weak var diastolicLabel: UserAttributeLabel!
    @IBOutlet weak var heartbeatLabel: UserAttributeLabel!
    
    @IBOutlet weak var systolicView: PlaceholderView!
    @IBOutlet weak var diastolicView: PlaceholderView!
    @IBOutlet weak var heartbeatView: PlaceholderView!

    @IBOutlet weak var dateTextField: MaskPlaceholderTextField!
    @IBOutlet weak var timeTextField: TimePickerTextField!
    
    var systolic : String!
    var diastolic : String!
    var heartbeat : String!
    
    var date: String!
    var time: String!
    
    weak var delegate: ManuaEntryBloodPressureDelegate?
    
    var bloodPressureReading : BloodPressureReading! {
        didSet {
            systolicView.setText(text: String(bloodPressureReading.systolic))
            diastolicView.setText(text: String(bloodPressureReading.diastolic))
            heartbeatView.setText(text: String(bloodPressureReading.heartRate))
            
            systolic = String(bloodPressureReading.systolic)
            diastolic = String(bloodPressureReading.diastolic)
            heartbeat = String(bloodPressureReading.heartRate)
            
            dateTextField.text = bloodPressureReading.dateCreated.getLocalShortDate()
            timeTextField.text = bloodPressureReading.dateCreated.getLocalShortTime()
            
            date = bloodPressureReading.dateCreated.getLocalShortDate()
            time = bloodPressureReading.dateCreated.getLocalShortTime()
            
            delegate?.textFieldCheckPassed(true, systolic: systolic, diastolic: diastolic, hearbeat: heartbeat, date: date, time: time)
            
            if bloodPressureReading.validated {
                systolicView.textField.isUserInteractionEnabled = false
                diastolicView.textField.isUserInteractionEnabled = false
                heartbeatView.textField.isUserInteractionEnabled = false
                dateTextField.isUserInteractionEnabled = false
                timeTextField.isUserInteractionEnabled = false

            }else{
                systolicView.textField.isUserInteractionEnabled = true
                diastolicView.textField.isUserInteractionEnabled = true
                heartbeatView.textField.isUserInteractionEnabled = true
                dateTextField.isUserInteractionEnabled = true
                timeTextField.isUserInteractionEnabled = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dateTextField.text = Date().getLocalShortDate()
        date = Date().getLocalShortDate()
        timeTextField.text = Date().getLocalShortTime()?.lowercased()
        
        dateTextField.isUserInteractionEnabled = true
        timeTextField.isUserInteractionEnabled = true
        
        systolicView.updatePlaceholder("000", labelPlaceholder: "mmHg")
        diastolicView.updatePlaceholder("000", labelPlaceholder: "mmHg")
        heartbeatView.updatePlaceholder("00", labelPlaceholder: "beats/min")
        
        heartbeatView.updateLabelWidth(width: 92.0)
        
        systolicView.textField.formatPattern = "###"
        diastolicView.textField.formatPattern = "###"
        heartbeatView.textField.formatPattern = "###"
        
        systolicView.textField.setDoneToolbar()
        diastolicView.textField.setDoneToolbar()
        heartbeatView.textField.setDoneToolbar()

        dateTextField.formatPattern = "##/##/####"
//        timeTextField.formatPattern = "##:## @@"
        timeTextField.autocapitalizationType = .none
        dateTextField.keyboardType = .numberPad
        dateTextField.setDoneToolbar()
        
        timeTextField.datePickerView.addTarget(self, action: #selector(dateChanged(field:)), for: UIControlEvents.valueChanged)
        dateTextField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: UIControlEvents.editingChanged)
        systolicView.textField.addTarget(self, action: #selector(ManualResultCell.textFieldChanged(textField:)), for: UIControlEvents.editingChanged)
        diastolicView.textField.addTarget(self, action: #selector(ManualResultCell.textFieldChanged(textField:)), for: UIControlEvents.editingChanged)
        heartbeatView.textField.addTarget(self, action: #selector(ManualResultCell.textFieldChanged(textField:)), for: UIControlEvents.editingChanged)

        for border in borderLines {
            border.backgroundColor = UIColor.dmsCloudyBlue
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dateChanged(field: UIDatePicker){
        print("• Time changed •")
        textFieldChanged(textField: dateTextField)
    }
    
    func textFieldChanged(textField: UITextField){
        
        let text : String = textField.text ?? ""
        switch textField {
            
        case dateTextField:
            if text.characters.count == 10 {
                date = textField.text
            }else if text.characters.count > 10 {
                date = textField.text?[0...9]
            }else{
                date = ""
            }
        case systolicView.textField:
            if text.characters.count <= 3 {
                systolic = textField.text
            }else{
                systolic = textField.text?[0...2]
            }
        case diastolicView.textField:
            if text.characters.count <= 3 {
                diastolic = textField.text
            }else{
                diastolic = textField.text?[0...2]
            }
        default:
            if text.characters.count <= 3 {
                heartbeat = textField.text
            }else{
                heartbeat = textField.text?[0...2]
            }
        }
        
        time = timeTextField.text
        
        if (date != nil && date != "") && (time != nil && time != "") && (systolic != nil && systolic != "") &&
            (diastolic != nil && diastolic != "") &&
            (heartbeat != nil && heartbeat != ""){
            delegate?.textFieldCheckPassed(true, systolic: systolic, diastolic: diastolic, hearbeat: heartbeat, date: date, time: time)
        }else{
            delegate?.textFieldCheckPassed(false, systolic: nil, diastolic: nil, hearbeat: nil, date: nil, time: nil)
        }
    }
}
