//
//  HistoryResultCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/19/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

let kErrorHeightConstant : CGFloat = 32.0

class HistoryResultCell: UITableViewCell {

    @IBOutlet weak var timeLabel: CellDateLabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLabel: ErrorLabel!
    @IBOutlet weak var errorHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var sysLabel: CellTitle!
    @IBOutlet weak var diaLabel: CellTitle!
    @IBOutlet weak var heartbeatLabel: CellTitle!
    
    @IBOutlet weak var sysResultLabel: CellResultLabel!
    @IBOutlet weak var diastolicResultLabel: CellResultLabel!
    @IBOutlet weak var heartbeatResultLabel: CellResultLabel!
    
    @IBOutlet weak var sysUnitLabel: CellTitle!
    @IBOutlet weak var diaUnitLabel: CellTitle!
    @IBOutlet weak var heartbeatUnitLabel: CellTitle!
    @IBOutlet weak var manualLabel: CellDateLabel!
    
    @IBOutlet weak var dateAndEditView: UIView!
    
    var bloodPressureReading : BloodPressureReading! {
        didSet {
            sysResultLabel.text = "\(bloodPressureReading.systolic)"
            diastolicResultLabel.text = "\(bloodPressureReading.diastolic)"
            heartbeatResultLabel.text = "\(bloodPressureReading.heartRate)"
            
            if bloodPressureReading.metaIncomplete {
                errorHeightConstraint.constant = kErrorHeightConstant
            }else{
                errorHeightConstraint.constant = 0
            }
            
            if bloodPressureReading.validated {
                manualLabel.text = nil
            }else{
                manualLabel.text = "Manual reading"
            }

            timeLabel.text = bloodPressureReading.dateCreated.getLocalShortTime()
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateAndEditView.backgroundColor = UIColor.dmsMetallicBlue75
        
        heartbeatUnitLabel.updateFont(size: 14.0)
        sysUnitLabel.updateFont(size: 14.0)
        diaUnitLabel.updateFont(size: 14.0)
        
        sysLabel.updateFont(size: 14.0)
        diaLabel.updateFont(size: 14.0)
        heartbeatLabel.updateFont(size: 14.0)
        
        sysResultLabel.updateFont(size: 30.0)
        diastolicResultLabel.updateFont(size: 30.0)
        heartbeatResultLabel.updateFont(size: 30.0)
        
        errorView.backgroundColor = UIColor.dmsMango
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
