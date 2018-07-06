//
//  CustomImageButton.swift
//  FTN
//
//  Created by Marko Stajic on 12/12/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class CustomImageButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override var isHighlighted: Bool {
        
        didSet {
            if isHighlighted {
                self.alpha = 0.6
                imageView?.alpha = 0.6
            }else{
                self.alpha = 1.0
                imageView?.alpha = 1.0
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
