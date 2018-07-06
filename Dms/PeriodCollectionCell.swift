//
//  PeriodCollectionCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/26/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class PeriodCollectionCell: UICollectionViewCell {

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var periodLabel: ResultActivityLabel!
    @IBOutlet weak var periodIndicatorView: UIView!
    
    var selectedCell : Bool = false {
        didSet {
            if selectedCell {
                self.periodIndicatorView.backgroundColor = UIColor.dmsLightNavy
            }else{
                self.periodIndicatorView.backgroundColor = UIColor.clear
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        periodLabel.textColor = UIColor.dmsLightNavy
        separatorView.backgroundColor = UIColor.dmsPaleGrey
        periodIndicatorView.backgroundColor = UIColor.clear
    }

}
