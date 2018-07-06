//
//  MedicationLabel.swift
//  FTN
//
//  Created by Marko Stajic on 1/10/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

class MedicationLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.textColor = UIColor.dmsBlueyGrey
        self.font = UIFont(name: Font.GothamBold, size: 14)
        
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateFont(size: CGFloat) {
        self.font = UIFont(name: Font.GothamBold, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}

