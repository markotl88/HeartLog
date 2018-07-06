//
//  ReadingsLabel.swift
//  FTN
//
//  Created by Marko Stajic on 11/30/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class ReadingsLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.textColor = UIColor.dmsPineGreen
        self.font = UIFont(name: Font.GothamMedium, size: 20)
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateFontSize(size: CGFloat) {
        self.font = UIFont(name: Font.GothamMedium, size: size)
    }

    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}


