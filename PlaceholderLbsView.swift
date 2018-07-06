//
//  PlaceholderLbsView.swift
//  FTN
//
//  Created by Marko Stajic on 1/25/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

class PlaceholderLbsView: UIView {
    
    var textField = MaskPlaceholderTextField()
    fileprivate var placeLabel = UILabel()
    
    var widthLabelConstraint = NSLayoutConstraint()
    var labelWidthConstraint : CGFloat = 30
    var tempPlaceholder : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.tintColor = UIColor.dmsLightNavy
        textField.textColor = UIColor.dmsLightNavy
        
        textField.font = UIFont(name: Font.GothamMedium, size: 17)
        textField.textAlignment = .right
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        
        placeLabel.textColor = UIColor.dmsCloudyBlueTwo
        placeLabel.font = UIFont(name: Font.GothamMedium, size: 17)
        placeLabel.textAlignment = .right
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.returnKeyType = .send
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.clipsToBounds = true
        self.addSubview(textField)
        self.addSubview(placeLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PlaceholderLbsView.setFirstResponder))
        placeLabel.addGestureRecognizer(tapGesture)
        
        updateTextConstraints()
    }
    fileprivate func updateTextConstraints() {
        
        // UITextField constraints
        let leadingTextFieldConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.addConstraint(leadingTextFieldConstraint)
        
        let trailingTextFieldConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: placeLabel, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.addConstraint(trailingTextFieldConstraint)
        
        let topTextFieldConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        self.addConstraint(topTextFieldConstraint)
        
        let bottomTextFieldConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.addConstraint(bottomTextFieldConstraint)
        
        
        // UILabel constraints
        let trailingLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.addConstraint(trailingLabelConstraint)
        
        let topLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        self.addConstraint(topLabelConstraint)
        
        let bottomLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.addConstraint(bottomLabelConstraint)
        
        widthLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: labelWidthConstraint)
        self.addConstraint(widthLabelConstraint)
        
    }
    
    func updateLabelColor(color: UIColor){
        self.placeLabel.textColor = color
    }
    
    func updateLabelWidth(width: CGFloat){
        self.removeConstraint(widthLabelConstraint)
        widthLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        self.addConstraint(widthLabelConstraint)
    }
    func setFirstResponder(){
        self.textField.becomeFirstResponder()
    }
    func setText(text: String) {
        self.textField.text = text
        if text == "" {
            self.placeLabel.textColor = UIColor.dmsCloudyBlueTwo
        }else{
            self.placeLabel.textColor = UIColor.dmsLightNavy
        }
    }
    func updatePlaceholder(_ placeholder: String, labelPlaceholder: String) {
        self.textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                  attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlueTwo, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 17)!])
        self.placeLabel.text = labelPlaceholder
    }
}

extension PlaceholderLbsView: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.characters.count == 1 && string == "" {
            placeLabel.textColor = UIColor.dmsCloudyBlueTwo
        }else{
            placeLabel.textColor = UIColor.dmsLightNavy
        }
        
        var txtAfterUpdate:NSString! = (self.textField.text ?? "") as NSString
        txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        
        if txtAfterUpdate.length <= 6 {
            return true
        }else{
            return false
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        self.placeLabel.textColor = UIColor.dmsLightNavy
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        if textField.text == "" || textField.text == nil {
            self.placeLabel.textColor = UIColor.dmsCloudyBlueTwo
        }else{
            self.placeLabel.textColor = UIColor.dmsLightNavy
        }
    }
    
}

