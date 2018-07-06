//
//  ActivityLabel.swift
//  FTN
//
//  Created by Marko Stajic on 12/9/16.
//  Copyright © 2018 FTN. All rights reserved.
//
import UIKit

class ActivityLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.textColor = UIColor.dmsLightNavy
        self.font = UIFont(name: Font.GothamBold, size: 17)
        
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


