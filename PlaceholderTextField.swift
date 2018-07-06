//
//  PlaceholderTextField.swift
//  FTN
//
//  Created by Marko Stajic on 11/18/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class PlaceholderTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.returnKeyType = .next
        self.autocapitalizationType = .words
        self.tintColor = UIColor.dmsLightNavy
        self.textAlignment = .right
        
        self.textColor = UIColor.dmsLightNavy
        self.font = UIFont(name: Font.GothamMedium, size: 17)
        
        if let place = self.placeholder{
            self.attributedPlaceholder = NSAttributedString(string: place,
                                                            attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlueTwo, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 17)!])
        }
        
    }
    
    func updateFont(size: CGFloat){
        self.font = UIFont(name: Font.GothamMedium, size: size)
    }
    
    func updatePlaceholder(_ placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlueTwo, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 17)!])
        
    }

}
