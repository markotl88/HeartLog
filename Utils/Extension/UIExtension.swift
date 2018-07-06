//
//  UIExtension.swift
//  DPS
//
//  Created by Marko Stajic on 12/26/17.
//  Copyright © 2017 Marko Stajic. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let mtsRed = UIColor(red: 232/255.0, green: 55/255.0, blue: 45/255.0, alpha: 1.0)
    
    // Menu
    static let menuText = UIColor.black
    static let menuHeaderText = UIColor.white
    
    // Cards
    static let cardBackgroundLight = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
    static let cardBackgroundDark = UIColor(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
    static let cardHeaderText = UIColor.white
    static let cardLiveText = UIColor(red: 237/255.0, green: 26/255.0, blue: 59/255.0, alpha: 1.0)
    static let cardDateText = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
    static let cardTimeText = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
    static let cardTeamText = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
    static let cardPriceText = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.62)
    static let cardActionText = UIColor(red: 0/255.0, green: 144/255.0, blue: 75/255.0, alpha: 1.0)
    
    // Page control
    static let pageControlUnselectedText = UIColor.white.withAlphaComponent(0.5)
    static let pageControlSelectedText = UIColor.white
    
    // News
    static let newsCategoryText = UIColor(red: 237/255.0, green: 26/255.0, blue: 59/255.0, alpha: 1.0)
    static let newsTitleText = UIColor(red: 95/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
    static let newsHeaderText = UIColor(red: 95/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)

    // Filter
    static let filterCategoryText = UIColor(red: 232/255.0, green: 55/255.0, blue: 45/255.0, alpha: 1.0)
    static let filterLeagueText = UIColor(red: 97/255.0, green: 97/255.0, blue: 97/255.0, alpha: 1.0)
    static let filterBottomLine = UIColor(red: 158/255.0, green: 158/255.0, blue: 158/255.0, alpha: 1.0)
    
    // Buy View
    static let titleLabelText = UIColor(red: 237/255.0, green: 26/255.0, blue: 59/255.0, alpha: 1.0)
    static let descriptionLabelText = UIColor(red: 141/255.0, green: 141/255.0, blue: 141/255.0, alpha: 1.0)
    static let countriesLabelText = UIColor(red: 141/255.0, green: 141/255.0, blue: 141/255.0, alpha: 0.62)
    static let buttonText = UIColor(red: 237/255.0, green: 26/255.0, blue: 59/255.0, alpha: 0.62)
    static let buyTicketText = UIColor(red: 237/255.0, green: 26/255.0, blue: 59/255.0, alpha: 1)
    static let countryLabelText = UIColor(red: 141/255.0, green: 141/255.0, blue: 141/255.0, alpha: 1.0)
}

extension UIFont {
    
    static let robotoCondensedRegular   = "RobotoCondensed-Regular"
    static let robotoCondensedBold      = "RobotoCondensed-Bold"
    static let robotoRegular            = "Roboto-Regular"
    static let robotoMedium             = "Roboto-Medium"
    static let robotoBold               = "Roboto-Bold"
    static let robotoLight              = "Roboto-Light"
    
    // Menu
    static let menu = UIFont(name: robotoRegular, size: 14)
    static let menuHeader = UIFont(name: robotoRegular, size: 14)
    
    // Cards
    static let cardHeader = UIFont(name: robotoRegular, size: 12)
    static let cardLive = UIFont(name: robotoMedium, size: 14)
    static let logoText = UIFont(name: robotoBold, size: 48)

    static let cardDate = UIFont(name: robotoRegular, size: 14)
    static let cardTime = UIFont(name: robotoRegular, size: 20)
    static let cardTeam = UIFont(name: robotoMedium, size: 14)
    static let cardPrice = UIFont(name: robotoLight, size: 14)
    static let cardAction = UIFont(name: robotoMedium, size: 14)
    
    // Page control
    static let pageControl = UIFont(name: robotoMedium, size: 14)
    
    // News
    static let newsCategory = UIFont(name: robotoBold, size: 12)
    static let newsTitle = UIFont(name: robotoRegular, size: 14)
    static let newsHeader = UIFont(name: robotoRegular, size: 14)
    
    // Filter
    static let filter = UIFont(name: robotoRegular, size: 15)
    
    // Buy View
    static let titleLabel = UIFont(name: robotoRegular, size: 20)
    static let descriptionLabel = UIFont(name: robotoRegular, size: 15)
    static let countriesLabel = UIFont(name: robotoRegular, size: 15)
    static let button = UIFont(name: robotoRegular, size: 14)
    static let country = UIFont(name: robotoRegular, size: 14)
    
    //Navigation
    static let navigationTitle = UIFont(name: robotoRegular, size: 17)
}


