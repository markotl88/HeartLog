//
//  CircleTimer.swift
//  FTN
//
//  Created by Marko Stajic on 12/15/16.
//  Copyright © 2018 FTN. All rights reserved.
//

class CircleTimer: UIView {
    
    var startAngle = 90.0
    
    override func draw(_ rect: CGRect) {
        self.drawHolderFrame(frame: rect)
    }
    
    func drawHolderFrame(frame: CGRect) {
        let ovalRect = CGRect(x: frame.minX+2, y: frame.minY+2, width: frame.size.width-4, height: frame.size.height-4)
        let ovalPath = UIBezierPath()
        
        let startAn : Double = M_PI/180 * -90.0
        let endAn : Double = M_PI/180 * Double(-self.startAngle)

        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width/2, startAngle: CGFloat(startAn), endAngle: CGFloat(endAn), clockwise: true)
        UIColor.dmsMetallicBlue.setStroke()
        ovalPath.lineWidth = 3
        ovalPath.stroke()
        
    }
}
class CircleTimerThin: UIView {
    
    var startAngle = 90.0
    
    override func draw(_ rect: CGRect) {
        self.drawHolderFrame(frame: rect)
    }
    
    func drawHolderFrame(frame: CGRect) {
        let ovalRect = CGRect(x: frame.minX+2, y: frame.minY+2, width: frame.size.width-4, height: frame.size.height-4)
        let ovalPath = UIBezierPath()
        
        let startAn : Double = M_PI/180 * -90.0
        let endAn : Double = M_PI/180 * Double(-self.startAngle)
        
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width/2, startAngle: CGFloat(startAn), endAngle: CGFloat(endAn), clockwise: true)
        UIColor.dmsPineGreen.setStroke()
        ovalPath.lineWidth = 3
        ovalPath.stroke()
        
    }
}


class PointsCircleTimer: UIView {
    
    var startAngle = 90.0
    
    override func draw(_ rect: CGRect) {
        self.drawHolderFrame(frame: rect)
    }
    
    func drawHolderFrame(frame: CGRect) {
        let ovalRect = CGRect(x: frame.minX+4, y: frame.minY+4, width: frame.size.width-8, height: frame.size.height-8)
        let ovalPath = UIBezierPath()
        
        let startAn : Double = M_PI/180 * -90.0
        let endAn : Double = M_PI/180 * Double(-self.startAngle)
        
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width/2, startAngle: CGFloat(startAn), endAngle: CGFloat(endAn), clockwise: true)
        UIColor.dmsPaleTealTwo.setStroke()
        ovalPath.lineWidth = 7
        ovalPath.stroke()
        
    }
}

