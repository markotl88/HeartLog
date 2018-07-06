//
//  ActivityCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

protocol ActivityDelegate: class {
    func returnActivity(activity: ActivityBP?)
}

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var activityLabel: ActivityLabel!
    @IBOutlet weak var activityInfoLabel: DurationLabel!
    @IBOutlet weak var borderLine: UIView!
    
    @IBOutlet weak var lightLabel: ResultActivityLabel!
    @IBOutlet weak var moderateLabel: ResultActivityLabel!
    @IBOutlet weak var heavyLabel: ResultActivityLabel!
    @IBOutlet weak var caffeineLabel: ResultActivityLabel!
    @IBOutlet weak var mealLabel: ResultActivityLabel!
    @IBOutlet weak var otherLabel: ResultActivityLabel!
    
    @IBOutlet weak var lightImage: UIImageView!
    @IBOutlet weak var moderateImage: UIImageView!
    @IBOutlet weak var heavyImage: UIImageView!
    @IBOutlet weak var caffeineImage: UIImageView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var otherImage: UIImageView!
    
    weak var delegate : ActivityDelegate?
    
    var activity : ActivityBP = .noActivity {
        didSet {
            setActivity(activity: activity)
        }
    }
    var currentActivity : ActivityBP?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderLine.backgroundColor = UIColor.dmsCloudyBlue
        
        lightLabel.activity = ActivityBP.light
        moderateLabel.activity = ActivityBP.moderate
        heavyLabel.activity = ActivityBP.heavy
        caffeineLabel.activity = ActivityBP.coffee
        mealLabel.activity = ActivityBP.meal
        otherLabel.activity = ActivityBP.other
        
        lightLabel.setSelected = false
        moderateLabel.setSelected = false
        heavyLabel.setSelected = false
        caffeineLabel.setSelected = false
        mealLabel.setSelected = false
        otherLabel.setSelected = false

        
    }
    
    func setActivity(activity: ActivityBP) {
        DispatchQueue.main.async {
            switch activity {
                
            case .noActivity:
                
                self.lightLabel.setSelected = false
                self.moderateLabel.setSelected = false
                self.heavyLabel.setSelected = false
                self.caffeineLabel.setSelected = false
                self.mealLabel.setSelected = false
                self.otherLabel.setSelected = false
                
                self.lightImage.image = #imageLiteral(resourceName: "iconActivity02Light")
                self.moderateImage.image = #imageLiteral(resourceName: "iconActivity03Moderate")
                self.heavyImage.image = #imageLiteral(resourceName: "iconActivity04Heavy")
                self.caffeineImage.image = #imageLiteral(resourceName: "mealBeforeBreakfast")
                self.mealImage.image = #imageLiteral(resourceName: "mealBeforeMeal")
                self.otherImage.image = #imageLiteral(resourceName: "other")
                
            case .light:
                
                self.lightLabel.setSelected = true
                self.moderateLabel.setSelected = false
                self.heavyLabel.setSelected = false
                self.caffeineLabel.setSelected = false
                self.mealLabel.setSelected = false
                self.otherLabel.setSelected = false
                
                self.lightImage.image = #imageLiteral(resourceName: "iconActivity02LightSelected")
                self.moderateImage.image = #imageLiteral(resourceName: "iconActivity03Moderate")
                self.heavyImage.image = #imageLiteral(resourceName: "iconActivity04Heavy")
                self.caffeineImage.image = #imageLiteral(resourceName: "mealBeforeBreakfast")
                self.mealImage.image = #imageLiteral(resourceName: "mealBeforeMeal")
                self.otherImage.image = #imageLiteral(resourceName: "other")
                
            case .moderate:
                
                self.lightLabel.setSelected = false
                self.moderateLabel.setSelected = true
                self.heavyLabel.setSelected = false
                self.caffeineLabel.setSelected = false
                self.mealLabel.setSelected = false
                self.otherLabel.setSelected = false
                
                self.lightImage.image = #imageLiteral(resourceName: "iconActivity02Light")
                self.moderateImage.image = #imageLiteral(resourceName: "iconActivity03ModerateSelected")
                self.heavyImage.image = #imageLiteral(resourceName: "iconActivity04Heavy")
                self.caffeineImage.image = #imageLiteral(resourceName: "mealBeforeBreakfast")
                self.mealImage.image = #imageLiteral(resourceName: "mealBeforeMeal")
                self.otherImage.image = #imageLiteral(resourceName: "other")
                
                
            case .heavy:
                
                self.lightLabel.setSelected = false
                self.moderateLabel.setSelected = false
                self.heavyLabel.setSelected = true
                self.caffeineLabel.setSelected = false
                self.mealLabel.setSelected = false
                self.otherLabel.setSelected = false
                
                self.lightImage.image = #imageLiteral(resourceName: "iconActivity02Light")
                self.moderateImage.image = #imageLiteral(resourceName: "iconActivity03Moderate")
                self.heavyImage.image = #imageLiteral(resourceName: "iconActivity04HeavySelected")
                self.caffeineImage.image = #imageLiteral(resourceName: "mealBeforeBreakfast")
                self.mealImage.image = #imageLiteral(resourceName: "mealBeforeMeal")
                self.otherImage.image = #imageLiteral(resourceName: "other")
                
            case .coffee:
                
                self.lightLabel.setSelected = false
                self.moderateLabel.setSelected = false
                self.heavyLabel.setSelected = false
                self.caffeineLabel.setSelected = true
                self.mealLabel.setSelected = false
                self.otherLabel.setSelected = false
                
                self.lightImage.image = #imageLiteral(resourceName: "iconActivity02Light")
                self.moderateImage.image = #imageLiteral(resourceName: "iconActivity03Moderate")
                self.heavyImage.image = #imageLiteral(resourceName: "iconActivity04Heavy")
                self.caffeineImage.image = #imageLiteral(resourceName: "mealBeforeBreakfastSelected")
                self.mealImage.image = #imageLiteral(resourceName: "mealBeforeMeal")
                self.otherImage.image = #imageLiteral(resourceName: "other")
                
            case .meal:
                
                self.lightLabel.setSelected = false
                self.moderateLabel.setSelected = false
                self.heavyLabel.setSelected = false
                self.caffeineLabel.setSelected = false
                self.mealLabel.setSelected = true
                self.otherLabel.setSelected = false
                
                self.lightImage.image = #imageLiteral(resourceName: "iconActivity02Light")
                self.moderateImage.image = #imageLiteral(resourceName: "iconActivity03Moderate")
                self.heavyImage.image = #imageLiteral(resourceName: "iconActivity04Heavy")
                self.caffeineImage.image = #imageLiteral(resourceName: "mealBeforeBreakfast")
                self.mealImage.image = #imageLiteral(resourceName: "mealBeforeMealSelected")
                self.otherImage.image = #imageLiteral(resourceName: "other")
                
            case .other:
                
                self.lightLabel.setSelected = false
                self.moderateLabel.setSelected = false
                self.heavyLabel.setSelected = false
                self.caffeineLabel.setSelected = false
                self.mealLabel.setSelected = false
                self.otherLabel.setSelected = true
                
                self.lightImage.image = #imageLiteral(resourceName: "iconActivity02Light")
                self.moderateImage.image = #imageLiteral(resourceName: "iconActivity03Moderate")
                self.heavyImage.image = #imageLiteral(resourceName: "iconActivity04Heavy")
                self.caffeineImage.image = #imageLiteral(resourceName: "mealBeforeBreakfast")
                self.mealImage.image = #imageLiteral(resourceName: "mealBeforeMeal")
                self.otherImage.image = #imageLiteral(resourceName: "otherSelected")
                
            }
            
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func changeActivity(_ sender: UIButton) {
        
        currentActivity = self.activity
        
        switch sender.tag {
        case 1:
            if currentActivity != .light {
                self.activity = .light
            }else{
                self.activity = .noActivity
            }
        case 2:
            if currentActivity != .moderate {
                self.activity = .moderate
            }else{
                self.activity = .noActivity
            }
        case 3:
            if currentActivity != .heavy {
                self.activity = .heavy
            }else{
                self.activity = .noActivity
            }
        case 4:
            if currentActivity != .coffee {
                self.activity = .coffee
            }else{
                self.activity = .noActivity
            }
        case 5:
            if currentActivity != .meal {
                self.activity = .meal
            }else{
                self.activity = .noActivity
            }
        case 6:
            if currentActivity != .other {
                self.activity = .other
            }else{
                self.activity = .noActivity
            }
        default:
            self.activity = .noActivity
        }
        delegate?.returnActivity(activity: self.activity)
    }
    
    
}
