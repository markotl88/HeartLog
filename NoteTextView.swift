//
//  NoteTextView.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//
import UIKit
import KMPlaceholderTextView

class NoteTextView: KMPlaceholderTextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        update()
    }
    
    func update(){
        self.layer.borderColor = UIColor.dmsCloudyBlueTwo.cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.dmsPaleGrey
        
        self.placeholderColor = UIColor.dmsCloudyBlueTwo
        self.placeholderFont = UIFont(name: Font.GothamMedium, size: 17)
        
        self.tintColor = UIColor.dmsLightNavy
        self.textColor = UIColor.dmsLightNavy
        self.font = UIFont(name: Font.GothamMedium, size: 17)
        
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateFontSize(size: CGFloat) {
        self.font = UIFont(name: Font.GothamMedium, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}

