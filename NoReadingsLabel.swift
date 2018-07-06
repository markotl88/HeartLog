//
//  NoReadingsLabel.swift
//  FTN
//
//  Created by Marko Stajic on 3/21/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

class NoReadingsLabel: UILabel {
    
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
        self.font = UIFont(name: Font.GothamMedium, size: 16)
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
    func updateFontSize(size: CGFloat) {
        self.font = UIFont(name: Font.GothamMedium, size: size)
    }
    
    
}

