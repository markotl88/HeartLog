//
//  ChartPointTextCircleView.swift
//  swift_charts
//
//  Created by ischuetz on 14/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

open class ChartPointMonthlyView : UIView {
    fileprivate let targetCenter : CGPoint
    open var viewTapped: ((ChartPointMonthlyView) -> ())?
    
    fileprivate var selectedColor : UIColor!
    fileprivate var deselectedColor : UIColor!
    
    open var selected: Bool = false {
        didSet {
            if self.selected {
                
                self.layer.borderColor = deselectedColor.cgColor
                self.layer.backgroundColor = UIColor.white.cgColor
                
                
            } else {
                self.layer.borderColor = deselectedColor.cgColor
                self.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    public init(chartPoint: ChartPoint, center: CGPoint, diameter: CGFloat, borderWidth: CGFloat, color: UIColor) {
        
        self.targetCenter = center
        
        super.init(frame: CGRect(x: 0, y: center.y - diameter / 2, width: diameter, height: diameter))
        
        selectedColor = color.withAlphaComponent(0.6)
        deselectedColor = color
        
        self.layer.cornerRadius = diameter/2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
        
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        
        let w: CGFloat = self.frame.size.width
        let h: CGFloat = self.frame.size.height
        let frame = CGRect(x: self.targetCenter.x - (w/2), y: self.targetCenter.y - (h/2), width: w, height: h)
        self.frame = frame
        
        //        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
        //            let w: CGFloat = self.frame.size.width
        //            let h: CGFloat = self.frame.size.height
        //            let frame = CGRect(x: self.targetCenter.x - (w/2), y: self.targetCenter.y - (h/2), width: w, height: h)
        //            self.frame = frame
        //
        //        }, completion: {finished in})
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewTapped?(self)
    }
}
open class ChartPointAverageView : UIView {
    fileprivate let targetCenter : CGPoint
    open var viewTapped: ((ChartPointAverageView) -> ())?
    
    fileprivate var upperCircle : UIView!
    fileprivate var lowerCircle : UIView!
    fileprivate var verticalLineView : UIView!

    fileprivate var selectedColor : UIColor!
    fileprivate var deselectedColor : UIColor!
    
    open var selected: Bool = false {
        didSet {
            if self.selected {
                
                self.upperCircle.layer.borderColor = deselectedColor.cgColor
                self.upperCircle.layer.backgroundColor = UIColor.white.cgColor
                self.lowerCircle.layer.borderColor = deselectedColor.cgColor
                self.lowerCircle.layer.backgroundColor = UIColor.white.cgColor
                self.verticalLineView.layer.backgroundColor = UIColor.dmsCloudyBlueTwo.cgColor

            } else {
                self.upperCircle.layer.borderColor = deselectedColor.cgColor
                self.upperCircle.layer.backgroundColor = UIColor.white.cgColor
                self.lowerCircle.layer.borderColor = deselectedColor.cgColor
                self.lowerCircle.layer.backgroundColor = UIColor.white.cgColor
                self.verticalLineView.layer.backgroundColor = UIColor.dmsCloudyBlueTwo.cgColor
            }
        }
    }
    
    public init(chartPoint: ChartPoint, center: CGPoint, diameter: CGFloat, borderWidth: CGFloat, color: UIColor) {
        
        self.targetCenter = center
        
        let circleRadius : CGFloat = diameter/5
        let circleDiameter : CGFloat = (diameter/5)*2
        
        super.init(frame: CGRect(x: 0, y: center.y - diameter / 2, width: diameter, height: diameter))
        
        upperCircle = UIView.init(frame: CGRect(x: (diameter-circleDiameter)/2, y: 0, width: circleDiameter, height: circleDiameter))
        upperCircle.layer.cornerRadius = circleDiameter/2
        upperCircle.layer.backgroundColor = UIColor.white.cgColor
        upperCircle.layer.borderWidth = borderWidth
        upperCircle.layer.borderColor = color.cgColor
        
        lowerCircle = UIView.init(frame: CGRect(x: (diameter-circleDiameter)/2, y: circleDiameter + circleRadius, width: circleDiameter, height: circleDiameter))
        lowerCircle.layer.cornerRadius = circleDiameter/2
        lowerCircle.layer.backgroundColor = UIColor.white.cgColor
        lowerCircle.layer.borderWidth = borderWidth
        lowerCircle.layer.borderColor = color.cgColor
        
        selectedColor = color.withAlphaComponent(0.6)
        deselectedColor = color
        
        verticalLineView = UIView.init(frame: CGRect(x: diameter/2 - 1, y: circleRadius, width: 2.0, height: circleDiameter/2*3))
        verticalLineView.layer.backgroundColor = UIColor.dmsCloudyBlueTwo.cgColor

        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.addSubview(verticalLineView)
        self.addSubview(upperCircle)
        self.addSubview(lowerCircle)
        
        self.isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        
        let w: CGFloat = self.frame.size.width
        let h: CGFloat = self.frame.size.height
        let frame = CGRect(x: self.targetCenter.x - (w/2), y: self.targetCenter.y - (h/2), width: w, height: h)
        self.frame = frame
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewTapped?(self)
    }
}

open class ChartPointSmallSingleView : UIView {
    fileprivate let targetCenter : CGPoint
    open var viewTapped: ((ChartPointSmallSingleView) -> ())?
    
    fileprivate var smallCircle : UIView!
    
    fileprivate var selectedColor : UIColor!
    fileprivate var deselectedColor : UIColor!
    
    open var selected: Bool = false {
        didSet {
            if self.selected {
                
                self.smallCircle.layer.borderColor = deselectedColor.cgColor
                self.smallCircle.layer.backgroundColor = UIColor.white.cgColor
                
            } else {
                self.smallCircle.layer.borderColor = deselectedColor.cgColor
                self.smallCircle.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    public init(chartPoint: ChartPoint, center: CGPoint, diameter: CGFloat, borderWidth: CGFloat, color: UIColor) {
        
        self.targetCenter = center
        
        let circleRadius : CGFloat = diameter/2
        
        super.init(frame: CGRect(x: 0, y: center.y - diameter/2 - diameter/3, width: diameter + 2*diameter/3, height: diameter + 2*diameter/3))
        
        smallCircle = UIView.init(frame: CGRect(x: diameter/3, y: diameter/3, width: diameter, height: diameter))
        smallCircle.layer.cornerRadius = circleRadius
        smallCircle.layer.backgroundColor = UIColor.white.cgColor
        smallCircle.layer.borderWidth = borderWidth
        smallCircle.layer.borderColor = color.cgColor

        selectedColor = color.withAlphaComponent(0.6)
        deselectedColor = color

        self.layer.backgroundColor = UIColor.clear.cgColor
        self.addSubview(smallCircle)
        self.isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        
        let w: CGFloat = self.frame.size.width
        let h: CGFloat = self.frame.size.height
        let frame = CGRect(x: self.targetCenter.x - (w/2), y: self.targetCenter.y - (h/2), width: w, height: h)
        self.frame = frame
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewTapped?(self)
    }
}


open class ChartPointSingleReadingView : UIView {
    fileprivate let targetCenter : CGPoint
    open var viewTapped: ((ChartPointSingleReadingView) -> ())?
    
    fileprivate var innerCircle : UIView!
    fileprivate var selectedColor : UIColor!
    fileprivate var deselectedColor : UIColor!
    
    open var selected: Bool = false {
        didSet {
            if self.selected {
                
                self.layer.borderColor = deselectedColor.cgColor
                self.innerCircle.layer.backgroundColor = deselectedColor.cgColor
                self.layer.backgroundColor = UIColor.white.cgColor

                
            } else {
                self.layer.borderColor = deselectedColor.cgColor
                self.innerCircle.layer.backgroundColor = deselectedColor.cgColor
                self.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    public init(chartPoint: ChartPoint, center: CGPoint, diameter: CGFloat, borderWidth: CGFloat, color: UIColor) {
        
        self.targetCenter = center
        
        super.init(frame: CGRect(x: 0, y: center.y - diameter / 2, width: diameter, height: diameter))
        
        innerCircle = UIView.init(frame: CGRect(x: ((diameter-10)/2)-1, y: ((diameter-10)/2)-1, width: (diameter-10), height: (diameter-10)))
        innerCircle.layer.cornerRadius = (diameter-10)/2
        innerCircle.layer.backgroundColor = color.cgColor
        
        selectedColor = color.withAlphaComponent(0.6)
        deselectedColor = color
        
        self.layer.cornerRadius = diameter/2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
        
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.addSubview(innerCircle)
        
        self.isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        
        let w: CGFloat = self.frame.size.width
        let h: CGFloat = self.frame.size.height
        let frame = CGRect(x: self.targetCenter.x - (w/2), y: self.targetCenter.y - (h/2), width: w, height: h)
        self.frame = frame
        
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
//            let w: CGFloat = self.frame.size.width
//            let h: CGFloat = self.frame.size.height
//            let frame = CGRect(x: self.targetCenter.x - (w/2), y: self.targetCenter.y - (h/2), width: w, height: h)
//            self.frame = frame
//            
//        }, completion: {finished in})
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewTapped?(self)
    }
}

open class ChartPointTextCircleView: UILabel {
   
    fileprivate let targetCenter: CGPoint
    open var viewTapped: ((ChartPointTextCircleView) -> ())?
    
    open var selected: Bool = false {
        didSet {
            if self.selected {
                self.textColor = UIColor.white
                self.layer.borderColor = UIColor.white.cgColor
                self.layer.backgroundColor = UIColor.black.cgColor
                
            } else {
                self.textColor = UIColor.black
                self.layer.borderColor = UIColor.black.cgColor
                self.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    public init(chartPoint: ChartPoint, center: CGPoint, diameter: CGFloat, cornerRadius: CGFloat, borderWidth: CGFloat, font: UIFont) {
        
        self.targetCenter = center
        
        super.init(frame: CGRect(x: 0, y: center.y - diameter / 2, width: diameter, height: diameter))

        self.textColor = UIColor.black
        self.text = "\(chartPoint.y)"//chartPoint.description
        self.font = font
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.textAlignment = NSTextAlignment.center
        self.layer.borderColor = UIColor.gray.cgColor
        
        let c = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        self.layer.backgroundColor = c.cgColor

        self.isUserInteractionEnabled = true
    }
   
    override open func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            let w: CGFloat = self.frame.size.width
            let h: CGFloat = self.frame.size.height
            let frame = CGRect(x: self.targetCenter.x - (w/2), y: self.targetCenter.y - (h/2), width: w, height: h)
            self.frame = frame
            
            }, completion: {finished in})
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewTapped?(self)
    }
}
