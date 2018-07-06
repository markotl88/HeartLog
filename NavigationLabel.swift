//
//  NavigationLabel.swift
//  FTN
//
//  Created by Marko Stajic on 1/7/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

class NavigationLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.textColor = UIColor.dmsMetallicBlue
        self.font = UIFont(name: Font.GothamMedium, size: 17)
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



