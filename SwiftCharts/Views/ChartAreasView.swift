//
//  ChartAreasView.swift
//  swift_charts
//
//  Created by ischuetz on 18/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

open class ChartAreasView: UIView {

    fileprivate let animDuration: Float
    fileprivate let color: UIColor
    fileprivate let animDelay: Float
    var height: CGFloat = 100
    
    //Added by me
    static var isSecond = false
    static var firstOriginY : CGFloat = 0
    
    public init(points: [CGPoint], frame: CGRect, color: UIColor, animDuration: Float, animDelay: Float) {
        self.color = color
        self.animDuration = animDuration
        self.animDelay = animDelay
        
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        self.show(path: self.generateAreaPath(points: points))
    }
    
    public init(points: [CGPoint], frame: CGRect, color: UIColor, animDuration: Float, animDelay: Float, height: CGFloat) {
        self.color = color
        self.animDuration = animDuration
        self.animDelay = animDelay
        self.height = height
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.show(path: self.generateAreaPath(points: points))
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func generateAreaPath(points: [CGPoint]) -> UIBezierPath {
        
        let progressline = UIBezierPath()
        progressline.lineWidth = 1.0
        progressline.lineCapStyle = .round
        progressline.lineJoinStyle = .round
        
        if let p = points.first {
            progressline.move(to: p)
        }
        
        for i in 1..<points.count {
            let p = points[i]
            progressline.addLine(to: p)
        }
        
        progressline.close()
        
        return progressline
    }
    
    fileprivate func show(path: UIBezierPath) {
        
        
        let areaLayer = CAShapeLayer()
        areaLayer.lineJoin = kCALineJoinBevel
        areaLayer.fillColor   = self.color.cgColor //self.color.cgColor
        areaLayer.lineWidth   = 2.0
        areaLayer.strokeEnd   = 0.0
        
        areaLayer.path = path.cgPath
        areaLayer.strokeColor = self.color.cgColor
//        self.layer.addSublayer(areaLayer) EDITED BY ME
        
        
        // ***** Added by me *****
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        if ChartAreasView.isSecond == false {
            ChartAreasView.isSecond = true
            ChartAreasView.firstOriginY = path.bounds.size.height
            gradientLayer.frame = CGRect(x: 0, y: 0, width: path.bounds.size.width+50, height: path.bounds.size.height-self.height);
        }else{
            ChartAreasView.isSecond = false
            print("Charts origin: \(ChartAreasView.firstOriginY)")
            gradientLayer.frame = CGRect(x: 0, y: 0, width: path.bounds.size.width+50, height: path.bounds.size.height + ChartAreasView.firstOriginY-self.height);
        }
        let colors = [self.color.cgColor, UIColor.white.cgColor]
        gradientLayer.colors = colors
        gradientLayer.mask = areaLayer
        self.layer.addSublayer(gradientLayer)
        // ***** ***** *****
        
        if self.animDuration > 0 {
            let maskLayer = CAGradientLayer()
            maskLayer.anchorPoint = CGPoint.zero
            
            let colors = [
                UIColor(white: 0, alpha: 0).cgColor,
                UIColor(white: 0, alpha: 1).cgColor]
            
            maskLayer.colors = colors
            maskLayer.bounds = CGRect(x: 0, y: 0, width: 0, height: self.layer.bounds.size.height)
            maskLayer.startPoint = CGPoint(x: 1, y: 0)
            maskLayer.endPoint = CGPoint(x: 0, y: 0)
            self.layer.mask = maskLayer
            
            let revealAnimation = CABasicAnimation(keyPath: "bounds")
            revealAnimation.fromValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: self.layer.bounds.size.height))
            
            let target = CGRect(x: self.layer.bounds.origin.x, y: self.layer.bounds.origin.y, width: self.layer.bounds.size.width + 2000, height: self.layer.bounds.size.height);
            
            revealAnimation.toValue = NSValue(cgRect: target)
            revealAnimation.duration = CFTimeInterval(self.animDuration)
            
            revealAnimation.isRemovedOnCompletion = false
            revealAnimation.fillMode = kCAFillModeForwards
            
            revealAnimation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.animDelay)
            self.layer.mask?.add(revealAnimation, forKey: "revealAnimation")
        }
    }
}
