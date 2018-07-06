//
//  JoyrideLabels.swift
//  FTN
//
//  Created by Marko Stajic on 4/22/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import Foundation

class JoyrideTitleLabel: UILabel {
    
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
        self.font = UIFont(name: Font.GothamBold, size: 24)
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}

class JoyrideSubtitleLabel: UILabel {
    
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
        self.font = UIFont(name: Font.GothamMedium, size: 20)
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}


