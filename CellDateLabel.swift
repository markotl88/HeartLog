//
//  CellDateLabel.swift
//  FTN
//
//  Created by Marko Stajic on 12/19/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class CellDateLabel: UILabel {
    
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
        self.font = UIFont(name: Font.GothamMedium, size: 12)
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateFont(size: CGFloat) {
        self.font = UIFont(name: Font.GothamMedium, size: size)
    }
    
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}



