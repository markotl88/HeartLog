//
//  CustomButton.swift
//  FTN
//
//  Created by Marko Stajic on 11/8/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var selectedColor : UIColor? = UIColor.dmsBlueGreen
    var enabledBackgroundColor : UIColor = UIColor.dmsOffBlue
    var enabledTitleColor : UIColor = UIColor.white
    
    var disabledBackgroundColor : UIColor = UIColor.dmsCloudyBlue
    var disabledTitleColor : UIColor = UIColor.white
    
    var higlightedTitleColor : UIColor = UIColor.white
    var higlightedBackgroundColor : UIColor = UIColor.dmsViridian

    var setEnabled : Bool = true {
        didSet{
            if setEnabled {
                self.isEnabled = true
                self.backgroundColor = enabledBackgroundColor
                self.setTitleColor(enabledTitleColor, for: UIControlState())
                self.setTitleColor(enabledTitleColor, for: .highlighted)

            } else {
                self.isEnabled = false
                self.backgroundColor = disabledBackgroundColor
                self.setTitleColor(disabledTitleColor, for: UIControlState())
                self.setTitleColor(higlightedTitleColor, for: .highlighted)
            }
        }
    }
    
    var setEnabledWithAnimation : Bool = true {
        didSet{
            if setEnabledWithAnimation {
                
                if self.isEnabled == false {
                    
                    self.isEnabled = true
                    self.backgroundColor = self.disabledBackgroundColor
                    UIView.animate(withDuration: 0.15, animations: {
                        self.backgroundColor = self.enabledBackgroundColor
                    }, completion: { (Bool) in
                        self.setTitleColor(self.enabledTitleColor, for: UIControlState())
                        self.setTitleColor(self.enabledTitleColor, for: .highlighted)
                        
                    })
                }

            } else {
                
                if self.isEnabled == true {
                    
                    self.isEnabled = false
                    self.backgroundColor = self.enabledBackgroundColor
                    UIView.animate(withDuration: 0.15, animations: {
                        self.backgroundColor = self.disabledBackgroundColor
                        
                    }, completion: { (Bool) in
                        self.setTitleColor(self.disabledTitleColor, for: UIControlState())
                        self.setTitleColor(self.higlightedTitleColor, for: .highlighted)
                        
                    })
                }
            }
        }
    }
    
    var setButtonSelected : Bool = false {
        didSet{
            if setButtonSelected {
                self.backgroundColor = selectedColor
                self.setTitleColor(enabledTitleColor, for: UIControlState())
                self.setTitleColor(higlightedTitleColor, for: .highlighted)  //check
                
            } else {
                self.backgroundColor = enabledBackgroundColor
                self.setTitleColor(enabledTitleColor, for: UIControlState())
                self.setTitleColor(higlightedTitleColor, for: .highlighted)
            }
        }
    }
    
    func expandingCircleAnimation(viewToAnimate: UIView, duration: Double){
        // Define the initial point (and rectangle) from where the circle will start to expand
        let midPoint = CGPoint(x: viewToAnimate.frame.midX, y: viewToAnimate.frame.midY)
        let initialSize = CGSize(width: 1, height: 1)
        let initialRect = CGRect(origin: midPoint, size: initialSize)
        
        // Calculate how much should circle expand (final circle size)
        let a = viewToAnimate.frame.width/2
        let b = viewToAnimate.frame.height/2
        let c = sqrt(a*a + b*b)
        
        // Define initial and final sizes/positionas of circle
        let circleMaskPathInitial = UIBezierPath(ovalIn: initialRect)
        let circleMaskPathFinal = UIBezierPath(ovalIn: viewToAnimate.frame.insetBy(dx: -c, dy: -c))
        
        // Add mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        viewToAnimate.layer.mask = maskLayer
        
        // Animate with that mask
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.duration = CFTimeInterval(duration)
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override var isHighlighted: Bool {
        
        didSet {
            if setButtonSelected == false {
                if isHighlighted {
                    backgroundColor = higlightedBackgroundColor
                    titleLabel?.alpha = 1.0
                }else{
                    if self.isEnabled {
                        backgroundColor = enabledBackgroundColor
                    }else {
                        backgroundColor = disabledBackgroundColor
                    }
                }
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
        self.titleLabel?.font = UIFont(name: Font.GothamBold, size: 17)
        self.titleLabel?.addTextSpacing(1.0)
    }
    
    func setSelectedButton(selected: Bool, selectionColor: UIColor = UIColor.dmsBlueGreen) {
        
        self.selectedColor = selectionColor
        self.setButtonSelected = selected
        
    }

    
    func updateEnabledButtonColors(backgroundColor:UIColor, titleColor: UIColor, highlightedColor : UIColor=UIColor.dmsViridian){
        enabledBackgroundColor = backgroundColor
        enabledTitleColor = titleColor
        higlightedBackgroundColor = highlightedColor
        
    }
    
    
    
    func updateFontSize(size: CGFloat){
        self.titleLabel?.font = UIFont(name: Font.GothamBold, size: size)
        self.titleLabel?.addTextSpacing(1.0)
    }
    
    func updateDisabledButtonColors(backgroundColor:UIColor, titleColor: UIColor){
        disabledBackgroundColor = backgroundColor
        disabledTitleColor = titleColor
    }
}
