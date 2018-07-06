//
//  TextFieldBottomLine.swift
//  FTN
//
//  Created by Marko Stajic on 11/9/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class TextFieldBottomLine: UIView {
    
    var textField = UITextField()
    fileprivate var borderLine = UIView()
    fileprivate var placeLabel = UILabel()
    
    var tempPlaceholder : String?
    
    fileprivate var widthLabelConstraint = NSLayoutConstraint()
    weak var delegate : TextFieldReturnDelegate?
    
    @IBInspectable var textFieldContent: String? = "" {
        didSet{
            
            if textFieldContent != "" {
                
                textField.text = textFieldContent
                self.widthLabelConstraint.constant = self.frame.width
                
                if let temporaryPlaceholder = tempPlaceholder {
                    self.placeLabel.textColor = UIColor.dmsCloudyBlue
                    self.placeLabel.text = temporaryPlaceholder //.uppercased()
                    self.textField.textColor = UIColor.dmsLightNavy
                }
                
                textField.placeholder = ""
                
            }else{
                self.widthLabelConstraint.constant = 0
                UIView.animate(withDuration: 0.2,
                               delay: TimeInterval(0),
                               options: UIViewAnimationOptions.curveEaseIn,
                               animations: { self.layoutIfNeeded() },
                               completion: { (finished) in self.updatePlaceholder(self.placeholder) })
            }
        }
    }
    
    @IBInspectable internal var placeholder: String = "" {
        didSet {
            
            if UIScreen.main.bounds.width < 375 {
                tempPlaceholder = placeholder //.uppercased()
                placeLabel.text = placeholder //.uppercased()
                textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlue, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 28)!])

            }else{
                tempPlaceholder = placeholder //.uppercased()
                placeLabel.text = placeholder //.uppercased()
                textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlue, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 34)!])

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    internal func setWarningPlaceholder(_ warning: String){
        
        tempPlaceholder = placeholder
        placeLabel.textColor = UIColor.dmsTomato
        placeLabel.text = warning //.uppercased()
        textField.textColor = UIColor.dmsTomato
    }
    
    fileprivate func commonInit() {
        
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.tintColor = UIColor.dmsLightNavy
        textField.textColor = UIColor.dmsLightNavy
        
        if UIScreen.main.bounds.width < 375 {
            textField.font = UIFont(name: Font.GothamMedium, size: 28)
        }else{
            textField.font = UIFont(name: Font.GothamMedium, size: 34)
        }
        
        textField.textAlignment = .center
        textField.borderStyle = .none
        
        textField.minimumFontSize = 17
        textField.adjustsFontSizeToFitWidth = true
        
        if let pl = textField.value(forKey: "_placeholderLabel") as? UILabel {
            pl.minimumScaleFactor = 0.5
        }
        
        placeLabel.textColor = UIColor.dmsCloudyBlueTwo
        placeLabel.font = UIFont(name: Font.GothamMedium, size: 14)
        placeLabel.textAlignment = .center
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.returnKeyType = .send
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        borderLine.backgroundColor = UIColor.dmsCloudyBlue
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.clipsToBounds = true
        self.addSubview(borderLine)
        self.addSubview(textField)
        self.addSubview(placeLabel)
        
        updateTextConstraints()
    }
    fileprivate func updateTextConstraints() {
        
//        // placeholder constraints
//        let leadingLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
//        self.addConstraint(leadingLabelConstraint)
//        
//        let trailingLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
//        self.addConstraint(trailingLabelConstraint)
        
        let centerLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        self.addConstraint(centerLabelConstraint)
        
        let topLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        self.addConstraint(topLabelConstraint)
        
        let heightLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 24)
        self.addConstraint(heightLabelConstraint)
        
        widthLabelConstraint = NSLayoutConstraint(item: placeLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
        self.addConstraint(widthLabelConstraint)
        
        // textField constraints
        let leadingTextViewConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.addConstraint(leadingTextViewConstraint)
        
        let trailingTextViewConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.addConstraint(trailingTextViewConstraint)
        
        let topTextViewConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: placeLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 15)
        self.addConstraint(topTextViewConstraint)
        
        let heightTextViewConstraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35)
        self.addConstraint(heightTextViewConstraint)
        
        
        // bottom line constraints
        let leadingBottomLineConstraint = NSLayoutConstraint(item: borderLine, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: textField, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.addConstraint(leadingBottomLineConstraint)
        
        let trailingBottomLineConstraint = NSLayoutConstraint(item: borderLine, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: textField, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.addConstraint(trailingBottomLineConstraint)
        
        let topBottomLineConstraint = NSLayoutConstraint(item: borderLine, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: textField, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 12)
        self.addConstraint(topBottomLineConstraint)
        
        let heightBottomLineConstraint = NSLayoutConstraint(item: borderLine, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
        self.addConstraint(heightBottomLineConstraint)
        
        
    }
    
    func updatePlaceholder(_ placeholder: String) {
        
        if UIScreen.main.bounds.width < 375 {
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                      attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlue, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 28)!])
        }else{
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                      attributes:[NSForegroundColorAttributeName: UIColor.dmsCloudyBlue, NSFontAttributeName : UIFont(name: Font.GothamMedium, size: 34)!])
        }
        
    }
}

extension TextFieldBottomLine: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if let temporaryPlaceholder = tempPlaceholder {
            self.placeLabel.textColor = UIColor.dmsCloudyBlueTwo
            self.placeLabel.text = temporaryPlaceholder //.uppercased()
            self.textField.textColor = UIColor.dmsLightNavy
        }
        // text hasn't changed yet, you have to compute the text AFTER the edit yourself
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if updatedString == "" {
            if let temporaryPlaceholder = tempPlaceholder {
                self.placeLabel.textColor = UIColor.dmsCloudyBlueTwo
                self.placeLabel.text = temporaryPlaceholder //.uppercased()
                self.textField.textColor = UIColor.dmsLightNavy
            }
        }
        
//        if textField.tag == TextFieldTag.cardNumber.rawValue {
//            //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
//            if range.length > 0
//            {
//                return true
//            }
//            
//            //Dont allow empty strings
//            if string == " "
//            {
//                return false
//            }
//            
//            //Check for max length including the spacers we added
//            if range.location == 23
//            {
//                return false
//            }
//            
//            var originalText = textField.text
//            let replacementText = string.replacingOccurrences(of: " ", with: "")
//            
//            //Verify entered text is a numeric value
//            let digits = CharacterSet.decimalDigits
//            for char in replacementText.unicodeScalars
//            {
//                if !digits.contains(UnicodeScalar(char.value)!)
//                {
//                    return false
//                }
//            }
//            
//            //Put an empty space after every 4 places
//            if originalText!.characters.count % 5 == 0
//            {
//                originalText?.append(" ")
//                textField.text = originalText
//            }
//            
//            return true
//        }
        
        // always return true so that changes propagate
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == ""{
            
            if let temporaryPlaceholder = tempPlaceholder {
                self.placeLabel.textColor = UIColor.dmsCloudyBlueTwo
                self.placeLabel.text = temporaryPlaceholder //.uppercased()
                self.textField.textColor = UIColor.dmsLightNavy
            }
            
            textField.placeholder = ""
            
            self.widthLabelConstraint.constant = self.frame.width
            
            UIView.animate(withDuration: 0.2,
                           delay: TimeInterval(0),
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { self.layoutIfNeeded() },
                           completion: nil)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        if textField.text == ""{
            
            self.widthLabelConstraint.constant = 0
            
            UIView.animate(withDuration: 0.2,
                           delay: TimeInterval(0),
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { self.layoutIfNeeded() },
                           completion: { (finished) in self.updatePlaceholder(self.placeholder) })
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldReturn(textField)
        return true
    }
}


