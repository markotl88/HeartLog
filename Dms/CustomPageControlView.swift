//
//  CustomPageControlView.swift
//  FTN
//
//  Created by Marko Stajic on 11/9/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class CustomPageControlView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout()
    }
    
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addSubviews()
        setupLayout()
    }
    
    init(numberOfPages: UInt, activePage: UInt) {
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat((numberOfPages - 1)*20 + 16), height: 16))
        addSubviews(numberOfPages: numberOfPages, activePage: activePage)
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    // MARK: Build View hierarchy
    func addSubviews(){
        // add subviews
    }

    
    func addSubviews(numberOfPages: UInt, activePage: UInt){
        // add subviews
        
        for i in 1...numberOfPages {
            let dot : UIView!
            if i == activePage {
                dot = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
                dot.layer.cornerRadius = 6
                dot.backgroundColor = UIColor.dmsOffBlue
            } else {
                dot = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
                dot.layer.cornerRadius = 4
                dot.backgroundColor = UIColor.dmsCloudyBlue
            }
            
            dot.center = CGPoint(x: CGFloat(8 + 20 * (i-1)), y: 8)
            self.addSubview(dot)

        }
        
        
    }
    
    func setupLayout(){
        // Autolayout
    }

    
}
