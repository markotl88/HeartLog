//
//  MyButton.swift
//  LayoutTest
//
//  Created by Marko Stajic on 12/12/16.
//  Copyright © 2016 Nolte. All rights reserved.
//

import UIKit

class CustomShapeButton : UIButton {
    
    var drawColor : UIColor? = UIColor.clear
    
    var setEnabled : Bool = true {
        didSet{
            if setEnabled {
                self.isEnabled = true
                self.backgroundColor = UIColor.clear
                self.setTitleColor(UIColor.white, for: UIControlState())
                self.setTitleColor(UIColor.white, for: .highlighted)
                self.setNeedsDisplay()
                
            } else {

                self.isEnabled = false
                self.backgroundColor = UIColor.clear
                self.setTitleColor(UIColor.white, for: UIControlState())
                self.setTitleColor(UIColor.white, for: .highlighted)
                self.setNeedsDisplay()

            }
        }
    }
    
    var setButtonSelected : Bool = false {
        didSet{
            if setButtonSelected {
                self.drawColor = UIColor.dmsBlueGreen
                self.backgroundColor = UIColor.clear
                self.setTitleColor(UIColor.white, for: UIControlState())
                self.setTitleColor(UIColor.white, for: .highlighted)
                self.setNeedsDisplay()
                
            } else {
                self.drawColor = UIColor.clear
                self.backgroundColor = UIColor.clear
                self.setTitleColor(UIColor.white, for: UIControlState())
                self.setTitleColor(UIColor.white, for: .highlighted)
                self.setNeedsDisplay()

            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
        self.adjustsImageWhenDisabled = false
        self.adjustsImageWhenHighlighted = false
    }
    
    func updateFontSize(size: CGFloat){
        self.titleLabel?.font = UIFont(name: Font.GothamBold, size: size)
        self.titleLabel?.addTextSpacing(1.0)
    }

    
//    override var isHighlighted: Bool {
//        
//        didSet {
//            
//            if setButtonSelected == false {
//                if isHighlighted {
//                    backgroundColor = higlightedBackgroundColor
//                    titleLabel?.alpha = 1.0
//                }else{
//                    if self.isEnabled {
//                        backgroundColor = enabledBackgroundColor
//                    }else {
//                        backgroundColor = disabledBackgroundColor
//                    }
//                }
//            }
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.titleLabel?.font = UIFont(name: Font.GothamBold, size: 17)
        self.titleLabel?.addTextSpacing(1.0)
    }
    
    func setSelectedButton(selected: Bool) {
        self.setButtonSelected = selected
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: rect.width, y: 0))
        let h = ((rect.width/5.0)*sqrt(3.0))/2.0
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, h/2, 0)
        polygonPath.addLine(to: CGPoint(x: rect.width, y: rect.height-h/2))
        polygonPath.addLine(to: CGPoint(x: rect.width-(4.0*rect.width/10.0), y: rect.height-h/2))
        polygonPath.addLine(to: CGPoint(x: rect.width/2, y: rect.height))
        polygonPath.addLine(to: CGPoint(x: rect.width-(6.0*rect.width/10.0), y: rect.height-h/2))
        polygonPath.addLine(to: CGPoint(x: 0, y: rect.height-h/2))
        polygonPath.addLine(to: CGPoint(x: 0, y: 0))
        polygonPath.close()
        self.drawColor!.setFill()
        polygonPath.fill()

    }

}
