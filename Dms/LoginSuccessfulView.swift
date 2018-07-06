//
//  LoginSuccessfulView.swift
//  FTN
//
//  Created by Marko Stajic on 12/13/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class LoginSuccessfulView: UIView {
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginSuccessfulLabel: TitleLabel!
    @IBOutlet var contentView: UIView!
    
    var imgListArray : [UIImage] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("LoginSuccessfulView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        contentView.backgroundColor = UIColor.white
        
        for countValue in 1...23 {
            let strImageName : String = "\(countValue)_Login"
            let image  = UIImage(named:strImageName)
            imgListArray.append(image!)
        }
        
        loginSuccessfulLabel.alpha = 0
        loginSuccessfulLabel.text = "Login successful!"
        loginSuccessfulLabel.updateTextColor(color: UIColor.dmsLightNavy)
        loginSuccessfulLabel.updateFontSize(size: 24)
        
    }
    
    public func startAnimation(){
        self.loginImageView.contentMode = .scaleAspectFit
        self.loginImageView.animationImages = imgListArray
        self.loginImageView.animationDuration = 0.77
        self.loginImageView.animationRepeatCount = 1
        self.loginImageView.image = loginImageView.animationImages?.last
        self.loginImageView.startAnimating()
        
        loginSuccessfulLabel.alpha = 0
        labelHeightConstraint.constant = 32
        UIView.animate(withDuration: 0.77) {
            self.loginSuccessfulLabel.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
}


