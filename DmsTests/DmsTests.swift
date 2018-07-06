 //
//  FTNTests.swift
//  FTNTests
//
//  Created by Marko Stajic on 11/7/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import XCTest
@testable import Dms

class DmsTests: XCTestCase {
    
    var vc : ViewController!
    var regCodeVC : RegistrationCodeVC!
    var str : String!
    
    override func setUp() {
        super.setUp()
        
        str = String()
        let storyboard = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        vc = nav.topViewController as! ViewController
        regCodeVC = storyboard.instantiateViewController(withIdentifier: String(describing: RegistrationCodeVC.self)) as! RegistrationCodeVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalculateSquare(){
        let p = vc.calculateSquare(number: 4)
        XCTAssert(p == 16, "Square not calculated correctly")
    }
    
    func testCalculateSqrt(){
        let p = vc.calculateSqrt(number: 4)
        XCTAssert(p == 2, "Sqrt not calculated correctly")
    }
    
    func testCalculateCube(){
        let p = vc.calculateCube(number: 4)
        XCTAssert(p == 64, "Cube not calculated correctly")
    }
    
    func testEmail(){
        str = "marko@gmail"
        XCTAssert(str.isValidEmail() == false, "Email not valid")
        
        str = "marko@gmail.com"
        XCTAssert(str.isValidEmail() == true, "Email valid")
    }
    
    func testContainsNumber(){
        str = "sgdgf01231"
        XCTAssert(str.containsNumber() == true, "String contains number")
        
        str = "msebdr"
        XCTAssert(str.containsNumber() == false, "String doesn't contain number")

        str = "msebdr0"
        XCTAssert(str.containsNumber() == true, "String contains number")

        str = "****90"
        XCTAssert(str.containsNumber() == true, "String contains number")

    }
    
    func testContainsLetter(){
        str = "dfsdfsfdsf3424"
        XCTAssert(str.containsLetter() == true, "String contains letter")
        
        str = "msEBRbdr"
        XCTAssert(str.containsLetter() == true, "String contains letter")
        
        str = "msEBdr0"
        XCTAssert(str.containsLetter() == true, "String contains letter")
        
        str = "****90"
        XCTAssert(str.containsLetter() == false, "String doesn't contains letter")
        
        str = "36436473"
        XCTAssert(str.containsLetter() == false, "String doesn't contains letter")


    }
    
    func testContainsSpecialCharacters(){
        str = "========"
        XCTAssert(str.containsSpecialCharacters() == true, "String contains spec chars")
        
        str = "(((())))"
        XCTAssert(str.containsSpecialCharacters() == true, "String contains spec chars")
        
        str = "@@@@@@@@"
        XCTAssert(str.containsSpecialCharacters() == true, "String contains spec chars")
        
        str = "|||||||||"
        XCTAssert(str.containsSpecialCharacters() == true, "String contains spec chars")
        
        str = "!!!!!!"
        XCTAssert(str.containsSpecialCharacters() == true, "String contains spec chars")
        
        str = "+++++++"
        XCTAssert(str.containsSpecialCharacters() == true, "String contains spec chars")
        
        str = "$$$$$"
        XCTAssert(str.containsSpecialCharacters() == true, "String contains spec chars")
        
        str = "%%%%%"
        XCTAssert(str.containsSpecialCharacters() == true, "String contains spec chars")

        str = "afdfsd8989"
        XCTAssert(str.containsSpecialCharacters() == false, "String doesn't contains spec chars")

    }
    
    func testNameString(){
        str = "Marko"
        XCTAssert(str.nameValid() == true, "String name is ok")
        
        str = "Stajic"
        XCTAssert(str.nameValid() == true, "String name is ok")
        
        str = "Ma%&"
        XCTAssert(str.nameValid() == false, "String name isn't ok")
        
        str = "4954584"
        XCTAssert(str.nameValid() == false, "String name isn't ok")
        
        str = "--------"
        XCTAssert(str.nameValid() == true, "String name is ok")
        
        str = "        "
        XCTAssert(str.nameValid() == true, "String name is ok")
        
        str = "+++++++++++"
        XCTAssert(str.nameValid() == false, "String name isn't ok")
        
        str = "Ana Marija"
        XCTAssert(str.nameValid() == true, "String name is ok")
        
        str = "Marija-Magdalena"
        XCTAssert(str.nameValid() == true, "String name is ok")

        str = "Van Nistelroy"
        XCTAssert(str.nameValid() == true, "String name is ok")

    }
    
    func testNameAndLastName(){
        var result = vc.checkName(name: "M", type: UIViewController.Name.FirstName, length: 2)
        XCTAssert(result.isTrue == false, result.message)
        
        result = vc.checkName(name: "Ma", type: UIViewController.Name.FirstName, length: 2)
        XCTAssert(result.isTrue == true, result.message)

        result = vc.checkName(name: "Marko", type: UIViewController.Name.FirstName, length: 2)
        XCTAssert(result.isTrue == true, result.message)

        result = vc.checkName(name: "Ana Marija", type: UIViewController.Name.FirstName, length: 2)
        XCTAssert(result.isTrue == true, result.message)
        
        result = vc.checkName(name: "Marija-Magdalena", type: UIViewController.Name.FirstName, length: 2)
        XCTAssert(result.isTrue == true, result.message)

        result = vc.checkName(name: "Jo", type: UIViewController.Name.LastName, length: 3)
        XCTAssert(result.isTrue == false, result.message)

        result = vc.checkName(name: "J", type: UIViewController.Name.LastName, length: 3)
        XCTAssert(result.isTrue == false, result.message)
        
        result = vc.checkName(name: "Hadzi-Petrovic", type: UIViewController.Name.LastName, length: 3)
        XCTAssert(result.isTrue == true, result.message)

        result = vc.checkName(name: "Hadzi Petrovic", type: UIViewController.Name.LastName, length: 3)
        XCTAssert(result.isTrue == true, result.message)

    }
    
    func testPassword(){
        var password = "msebdr357"
        var result = vc.checkPassword(password: password, confirmPassword: password, length: 8)
        XCTAssert(result.isTrue == true, result.message)
        
        password = "ms*357"
        result = vc.checkPassword(password: password, confirmPassword: password, length: 8)
        XCTAssert(result.isTrue == false, result.message)
        
        password = "msebdr357"
        result = vc.checkPassword(password: password, confirmPassword: "msebdr35789", length: 8)
        XCTAssert(result.isTrue == false, result.message)
        
        password = "msebdr_12"
        result = vc.checkPassword(password: password, confirmPassword: password, length: 8)
        
        XCTAssert(result.isTrue == true, result.message)
        
        password = "1221222"
        result = vc.checkPassword(password: password, confirmPassword: password, length: 8)
        
        XCTAssert(result.isTrue == false, result.message)
        
        password = "****212129"
        result = vc.checkPassword(password: password, confirmPassword: password, length: 8)
        
        XCTAssert(result.isTrue == false, result.message)

        password = "&^$@#&*#&*"
        result = vc.checkPassword(password: password, confirmPassword: password, length: 8)
        
        XCTAssert(result.isTrue == false, result.message)

        password = "fgfgdfgddfg"
        result = vc.checkPassword(password: password, confirmPassword: password, length: 8)
        
        XCTAssert(result.isTrue == false, result.message)


    }
    
    func testDate(){
        XCTAssert("09/30/2000".isDateValid() == true, "Date is ok")
        XCTAssert("01/08/1998".isDateValid() == true, "Date is ok")
        XCTAssert("01/20/1998".isDateValid() == true, "Date is ok")
        XCTAssert("01/29/1998".isDateValid() == true, "Date is ok")

        XCTAssert("01/32/1998".isDateValid() == false, "Date isn't ok")
        XCTAssert("13/012/1998".isDateValid() == false, "Date isn't ok")
        XCTAssert("11/43/1998".isDateValid() == false, "Date isn't ok")

        XCTAssert("15/01/1900".isDateValid() == false, "Date isn't ok")
        XCTAssert("30/01/1954".isDateValid() == false, "Date isn't ok")
        XCTAssert("11/201/1900".isDateValid() == false, "Date isn't ok")
        XCTAssert("01/401/1954".isDateValid() == false, "Date isn't ok")

        XCTAssert("01/06/1943".isDateValid() == true, "Date is ok")
        XCTAssert("04/22/1966".isDateValid() == true, "Date is ok")
        XCTAssert("15/01/1900".isDateValid() == false, "Date isn't ok")
        XCTAssert("800".isDateValid() == false, "Date is ok")
        XCTAssert("0".isDateValid() == false, "Date is ok")


    }

    
    
}
