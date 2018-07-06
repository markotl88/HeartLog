//
//  HeaderPointsLabel.swift
//  FTN
//
//  Created by Marko Stajic on 3/11/17.
//  Copyright © 2017 DMS. All rights reserved.
//


import UIKit

class HeaderPointsLabel: UILabel {
    
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
        self.font = UIFont(name: Font.GothamBook, size: 14.0)
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateFont(size: CGFloat) {
        self.font = UIFont(name: Font.GothamBook, size: size)
    }
    
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}

