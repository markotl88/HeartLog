//
//  MoodCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

protocol MoodDelegate: class {
    func returnMood(mood: Mood?)
}

class MoodCell: UITableViewCell {
    
    @IBOutlet weak var borderLine: UIView!
    @IBOutlet weak var moodLabel: ActivityLabel!
    @IBOutlet weak var moodInfoLabel: DurationLabel!
    
    @IBOutlet weak var happyLabel: MoodLabel!
    @IBOutlet weak var okLabel: MoodLabel!
    @IBOutlet weak var neutralLabel: MoodLabel!
    @IBOutlet weak var sadLabel: MoodLabel!
    
    @IBOutlet weak var happyImage: UIImageView!
    @IBOutlet weak var okImage: UIImageView!
    @IBOutlet weak var neutralImage: UIImageView!
    @IBOutlet weak var sadImage: UIImageView!
    
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    
    weak var delegate : MoodDelegate?
    
    var mood : Mood = .NoMood {
        didSet {
            setMood(mood: mood)
        }
    }
    var currentMood : Mood?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderLine.backgroundColor = UIColor.dmsCloudyBlue
    }
    
    func setMood(mood: Mood) {
        
        DispatchQueue.main.async {
            
            switch mood {
            case .Happy:
                
                self.happyLabel.mood = .Happy
                self.okLabel.mood = Mood.NoMood
                self.neutralLabel.mood = Mood.NoMood
                self.sadLabel.mood = Mood.NoMood
                
                self.happyImage.image = #imageLiteral(resourceName: "iconFace01Happy")
                self.okImage.image = #imageLiteral(resourceName: "iconFace02OkDeselected")
                self.neutralImage.image = #imageLiteral(resourceName: "iconFace03NeutralDeselected")
                self.sadImage.image = #imageLiteral(resourceName: "iconFace04SadDeselected")
                
            case .Ok:
                
                self.okLabel.mood = .Ok
                self.happyLabel.mood = Mood.NoMood
                self.neutralLabel.mood = Mood.NoMood
                self.sadLabel.mood = Mood.NoMood
                
                self.okImage.image = #imageLiteral(resourceName: "iconFace02Ok")
                self.happyImage.image = #imageLiteral(resourceName: "iconFace01HappyDeselected")
                self.neutralImage.image = #imageLiteral(resourceName: "iconFace03NeutralDeselected")
                self.sadImage.image = #imageLiteral(resourceName: "iconFace04SadDeselected")
                
                
            case .Neutral:
                
                self.neutralLabel.mood = .Neutral
                self.happyLabel.mood = Mood.NoMood
                self.okLabel.mood = Mood.NoMood
                self.sadLabel.mood = Mood.NoMood
                
                self.neutralImage.image = #imageLiteral(resourceName: "iconFace03Neutral")
                self.happyImage.image = #imageLiteral(resourceName: "iconFace01HappyDeselected")
                self.okImage.image = #imageLiteral(resourceName: "iconFace02OkDeselected")
                self.sadImage.image = #imageLiteral(resourceName: "iconFace04SadDeselected")
                
                
            case .Sad:
                
                self.sadLabel.mood = .Sad
                self.happyLabel.mood = Mood.NoMood
                self.okLabel.mood = Mood.NoMood
                self.neutralLabel.mood = Mood.NoMood
                
                self.sadImage.image = #imageLiteral(resourceName: "iconFace04Sad")
                self.happyImage.image = #imageLiteral(resourceName: "iconFace01HappyDeselected")
                self.okImage.image = #imageLiteral(resourceName: "iconFace02OkDeselected")
                self.neutralImage.image = #imageLiteral(resourceName: "iconFace03NeutralDeselected")
                
            default:
                
                self.okLabel.mood = Mood.NoMood
                self.neutralLabel.mood = Mood.NoMood
                self.sadLabel.mood = Mood.NoMood
                self.happyLabel.mood = Mood.NoMood
                
                self.okImage.image = #imageLiteral(resourceName: "iconFace02OkDeselected")
                self.neutralImage.image = #imageLiteral(resourceName: "iconFace03NeutralDeselected")
                self.sadImage.image = #imageLiteral(resourceName: "iconFace04SadDeselected")
                self.happyImage.image = #imageLiteral(resourceName: "iconFace01HappyDeselected")
            }
        }
    }
    
    @IBAction func changeMood(_ sender: UIButton) {
        
        currentMood = self.mood
        
        switch sender.tag {
        case 1:
            if currentMood != .Happy {
                self.mood = .Happy
            }else{
                self.mood = .NoMood
            }
        case 2:
            if currentMood != .Ok {
                self.mood = .Ok
            }else{
                self.mood = .NoMood
            }
            
        case 3:
            if currentMood != .Neutral {
                self.mood = .Neutral
            }else{
                self.mood = .NoMood
            }
            
        case 4:
            if currentMood != .Sad {
                self.mood = .Sad
            }else{
                self.mood = .NoMood
            }
            
        default:
            self.mood = .NoMood
        }
        
        
        delegate?.returnMood(mood: self.mood)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
