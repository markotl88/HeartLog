//
//  ResultCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var borderLines: [UIView]!
    @IBOutlet weak var diastolicLabel: CellTitle!
    @IBOutlet weak var systolicLabel: CellTitle!
    @IBOutlet weak var heartBeatLabel: CellTitle!
    
    @IBOutlet weak var sysResultLabel: CellResultLabel!
    @IBOutlet weak var diaResultLabel: CellResultLabel!
    @IBOutlet weak var heartBeatResLabel: CellResultLabel!
    
    @IBOutlet weak var hearBeatUnitLabel: ReadingsLabel!
    @IBOutlet weak var sysUnitLabel: ReadingsLabel!
    @IBOutlet weak var diaUnitLabel: ReadingsLabel!
    
    var bloodPressureReading : BloodPressureReading! {
        didSet {
            sysResultLabel.text = "\(bloodPressureReading.systolic)"
            diaResultLabel.text = "\(bloodPressureReading.diastolic)"
            heartBeatResLabel.text = "\(bloodPressureReading.heartRate)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.dmsCloudyBlue
        containerView.layer.shadowColor = UIColor.dmsCloudyBlueTwo.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.shadowOpacity = 1;
        containerView.layer.shadowRadius = 1.0;

        // Initialization code
        hearBeatUnitLabel.updateFontSize(size: 17.0)
        sysUnitLabel.updateFontSize(size: 17.0)
        diaUnitLabel.updateFontSize(size: 17.0)
        
        for border in borderLines {
            border.backgroundColor = UIColor.dmsCloudyBlue
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
