//
//  HomeLabel.swift
//  FTN
//
//  Created by Marko Stajic on 2/17/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

class HomeLabel: UILabel {
    
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
        self.font = UIFont(name: Font.GothamBook, size: 18.0)
    }
    
    func updateFontSize(size: CGFloat){
        self.font = UIFont(name: Font.GothamBook, size: size)
    }
    
    
}

