//
//  ResultActivityLabel.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit



class ResultActivityLabel: UILabel {
    
    var activity : ActivityBP! {
        didSet {
            self.text = activity.rawValue
        }
    }
    
    var setSelected : Bool = false {
        didSet {
            if setSelected {
                self.textColor = UIColor.dmsViridian
            }else{
                self.textColor = UIColor.dmsCloudyBlueTwo
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.textColor = UIColor.dmsViridian
        self.font = UIFont(name: Font.GothamMedium, size: 14)
        
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}
