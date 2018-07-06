//
//  DataUtils.swift
//  DPS
//
//  Created by Qidenus on 1/12/18.
//  Copyright © 2018 Qidenus. All rights reserved.
//

import Foundation

class DateFormat {
    static let server = "YYYY-MM-dd HH:mm:ss"
    static let serverFullTime = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    static let application = "dd. MMMM yyyy."
    static let timeOnly = "HH:mm"
    static let fullTime = "dd. MMMM, HH:mm"
    static let fullTimeYear = "dd. MMMM yyyy, HH:mm"
    static let fullTimeYearWithoutZeros = "d. MMMM yyyy, H:mm"
    static let dateOnly = "dd"
    static let monthOnly = "MMMM"
    static let monthAndYear = "MMMM yyyy"
    static let calendar = "yyyy-MM-dd"
}

class TimeZoneAbbreviation {
    static let Serbia = TimeZone(identifier: "Europe/Belgrade")?.abbreviation() ?? ""
    static let CurrentTimeZone = TimeZone.current.abbreviation() ?? "" 
}

class LocaleAbbreviation {
    static let Montenegro = "sr-Latn-Me"
    static let Usa = "en-US"
    static let SerbiaLatin = "sr-Latn"
    static let Serbia = "sr-RS"
}

extension Date {
    func string(format: String, locale: String = "en-US", timeZone: String = "GMT+0:00") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation:timeZone)
        dateFormatter.locale = Locale(identifier: locale)
        return dateFormatter.string(from: self)
    }
    func string(format: String, locale: String = "en-US", timeZone: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let timeZone = timeZone {
            dateFormatter.timeZone = TimeZone(abbreviation:timeZone)
        }else{
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        }
        dateFormatter.locale = Locale(identifier: locale)
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    func date(format: String, locale: String = "en-US", timeZone: String = "GMT+0:00") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.locale = Locale(identifier: locale)
        return dateFormatter.date(from: self)
    }
    func date(format: String, locale: String = "en-US", timeZone: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let timeZone = timeZone {
            dateFormatter.timeZone = TimeZone(abbreviation:timeZone)
        }else{
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        }
        dateFormatter.locale = Locale(identifier: locale)
        return dateFormatter.date(from: self)
    }

    var isValidPassword : Bool {
        
        if(self.count>=7 && self.count<=16){
        }else{
            return false
        }
        
        let letterRegEx  = ".*[a-zA-Z]+.*"
        let letterTest = NSPredicate(format:"SELF MATCHES %@", letterRegEx)
        let letterResult = letterTest.evaluate(with: self)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = numberTest.evaluate(with: self)
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        var isSpecial :Bool = false
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            print("could not handle special characters")
            isSpecial = true
        }else{
            isSpecial = false
        }
        return (letterResult || numberResult) && isSpecial
    }
}
