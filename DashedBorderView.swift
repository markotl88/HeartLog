//
//  DashedBorderView.swift
//  Tets
//
//  Created by Marko Stajic on 2/17/17.
//  Copyright © 2017 moxie. All rights reserved.
//

import UIKit

class DashedBorderView: UIView {
    
    let _border = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        _border.strokeColor = UIColor.dmsPaleTealTwo.cgColor
        _border.fillColor = nil
        _border.lineDashPattern = [0.5, 2.5]
        _border.lineWidth = 12
        self.layer.addSublayer(_border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.bounds.width/2).cgPath
        _border.frame = self.bounds
    }
}

