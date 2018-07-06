//
//  LogoLabel.swift
//  FTN
//
//  Created by Marko Stajic on 12/16/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class LogoLabel: UILabel {
    
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
        self.font = UIFont(name: Font.GothamBook, size: 43)
        self.addTextSpacing(0.9)
    }
    
    func updateFontSize(size: CGFloat){
        self.font = UIFont(name: Font.GothamBook, size: size)
    }

    
}



