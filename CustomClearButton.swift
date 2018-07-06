
//
//  CustomClearButton.swift
//  FTN
//
//  Created by Marko Stajic on 12/12/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class CustomClearButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override var isHighlighted: Bool {
        
        didSet {
            if isHighlighted {
                self.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.6)
            }else{
                self.backgroundColor = UIColor.clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.adjustsImageWhenDisabled = false
        self.adjustsImageWhenHighlighted = false
    }
    
}

