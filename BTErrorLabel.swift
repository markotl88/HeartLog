//
//  BTErrorLabel.swift
//  FTN
//
//  Created by Marko Stajic on 3/18/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

class BTErrorLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.textColor = UIColor.dmsTomato
        self.font = UIFont(name: Font.GothamBook, size: 17)
        
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
    func updateFontSize(size: CGFloat){
        self.font = UIFont(name: Font.GothamBook, size: size)
    }
}
