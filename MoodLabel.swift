//
//  MoodLabel.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

class MoodLabel: UILabel {
    
    var mood : Mood = Mood.NoMood {
        didSet {
            self.text = mood.rawValue
            
            switch mood {
            case .Happy:
                self.textColor = UIColor.dmsViridian
            case .Ok:
                self.textColor = UIColor.dmsOkBlue
            case .Neutral:
                self.textColor = UIColor.dmsOrange
            case .Sad:
                self.textColor = UIColor.dmsSad
            default:
                self.textColor = UIColor.dmsLightNavy
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    func update(){
        self.textColor = UIColor.dmsViridian
        self.font = UIFont(name: Font.GothamBold, size: 14)
        
    }
    
    func updateFont(fontName: String, size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func updateTextColor(color: UIColor) {
        self.textColor = color
    }
    
}
