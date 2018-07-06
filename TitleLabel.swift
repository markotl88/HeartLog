//
//  TitleLabel.swift
//  FTN
//
//  Created by Marko Stajic on 11/8/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.textColor = UIColor.white
        self.font = UIFont(name: Font.GothamBold, size: 36)
        self.addTextSpacing(0.8)
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateFontSize(size: CGFloat) {
        self.font = UIFont(name: Font.GothamBold, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }

}

