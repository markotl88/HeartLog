//
//  BPResultVC.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

final class BPResultVC: CommonVC, StoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: CustomButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var bloodPressureReading : BloodPressureReading!
    
    var tempMood : String?
    var tempActivity : String?
    var tempNote : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        if bloodPressureReading != nil {
            tempMood = bloodPressureReading.mood
            tempActivity = bloodPressureReading.activity
            tempNote = bloodPressureReading.note
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(BPResultVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BPResultVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: true)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]
        setBloodPressureReadingParameters()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setBloodPressureReadingParameters(){
        
        let currentDate = Date()
        var localTimeZoneAbbreviation: String { return TimeZone.current.secondsFromGMT().timezoneOffset() }
        addTwoLineNavigationTitle(title: "Blood Pressure Results", subtitle: currentDate.getLongDateAndTime(utcOffset: localTimeZoneAbbreviation))
        
        if bloodPressureReading != nil {
            bloodPressureReading.timestamp = currentDate.getTimestamp(utcOffset: nil)
            bloodPressureReading.utcOffset = localTimeZoneAbbreviation
            bloodPressureReading.source = "ihealth" // TODO: Hardcoded
        }
        uploadToServer()
    }
    func uploadToServer(){
        if bloodPressureReading != nil {
            DataManager.sharedInstance.postBloodPressureReading(bloodPressureReading: bloodPressureReading!, completion: { (SingleBloodPressureReadingResponse) in
                if SingleBloodPressureReadingResponse.success {
                    self.bloodPressureReading = SingleBloodPressureReadingResponse.bloodPressureReading
                }else{
//                    self.showError(errorMessage: "Failed to upload blood pressure reading")
                }
            })
        }else{
            showError(errorMessage: "Measurement error")
        }
    }
    
    @objc func dismissViewController() {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func updateViews() {
        
        let homeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "homeWhite"), style: .plain, target: self, action: #selector(dismissViewController))
        homeButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = homeButton

        let tap = UITapGestureRecognizer(target: self, action: #selector(BPResultVC.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        doneButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsOffBlue, titleColor: UIColor.white)
        doneButton.setEnabled = true

        
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]
        //        self.title = NSLocalizedString("general.appname", comment: "")
        
        tableView.backgroundColor = UIColor.dmsCloudyBlue
        //        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 216
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing: BPResultCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BPResultCell.self))
        tableView.register(UINib(nibName: String(describing: ReadingHeaderCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ReadingHeaderCell.self))
        tableView.register(UINib(nibName: String(describing: MoodCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoodCell.self))
        tableView.register(UINib(nibName: String(describing: NoteCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NoteCell.self))
        tableView.register(UINib(nibName: String(describing: ActivityCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ActivityCell.self))
    }
    
    func checkAllFields() -> (passed: Bool, message: String){
        if tempMood == nil {
            return (false, "Mood is required")
        }else if tempActivity == nil {
            return (false, "Activity is required")
        }else{
            return (true, "Ok")
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        if bloodPressureReading != nil {
            
            let checkResult = checkAllFields()
            if !checkResult.passed {
                self.showError(errorMessage: checkResult.message)
                return
            }

            startLoading()
            bloodPressureReading.mood = tempMood
            bloodPressureReading.activity = tempActivity
            bloodPressureReading.note = tempNote
            
            if bloodPressureReading.mood != nil && bloodPressureReading.activity != nil && bloodPressureReading.note != nil {
                bloodPressureReading.metaIncomplete = false
            } else {
                bloodPressureReading.metaIncomplete = true
            }
            
            let currentDate = Date()
            var localTimeZoneAbbreviation: String { return TimeZone.current.secondsFromGMT().timezoneOffset() }
            bloodPressureReading.lastUpdated = currentDate.getTimestamp(utcOffset: nil)
            
            DataManager.sharedInstance.editBloodPressureReading(bloodPressureReading: bloodPressureReading!, completion: { (SingleBloodPressureReadingResponse) in
                self.stopLoading()
                if SingleBloodPressureReadingResponse.success {
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                    print("Error updating BP Result: \(SingleBloodPressureReadingResponse.error?.toString())")
                }
            })
            
        }else{
            showError(errorMessage: "Measurement error")
        }
    }

}

extension BPResultVC : MoodDelegate, ActivityDelegate, NoteDelegate {
    
    func returnMood(mood: Mood?) {
        if bloodPressureReading != nil {
            if let mood = mood {
                tempMood = mood.jsonRepresentation
            }else{
                bloodPressureReading.mood = nil
            }
        }
    }
    func returnActivity(activity: ActivityBP?) {
        if bloodPressureReading != nil {
            if activity != nil {
                tempActivity = activity!.jsonRepresentation
            }else{
                bloodPressureReading.activity = nil
            }
        }
        
    }
    func returnNote(note: String?) {
        if note != "" {
            tempNote = note
        }
    }
    func scrollToBottom() {
        self.tableView.scrollToRow(at: IndexPath(row: 3, section: 1), at: UITableViewScrollPosition.bottom, animated: true)
    }
}

extension BPResultVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 4
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 137
        default:
            switch indexPath.row {
            case 0:
                return 95
            case 1:
                return 236
            case 2:
                return 339
            case 3:
                return 170
            default:
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let resultCell = tableView.dequeueReusableCell(withIdentifier: String(describing: BPResultCell.self), for: indexPath) as? BPResultCell {
                resultCell.selectionStyle = .none
                if bloodPressureReading != nil {
                    resultCell.bloodPressureReading = bloodPressureReading
                }
                return resultCell
            }
        default:
            switch indexPath.row {
            case 0:
                if let headerReadingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReadingHeaderCell.self), for: indexPath) as? ReadingHeaderCell {
                    headerReadingCell.selectionStyle = .none
                    return headerReadingCell
                }
            case 1:
                if let moodCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoodCell.self), for: indexPath) as? MoodCell {
                    moodCell.selectionStyle = .none
                    moodCell.delegate = self
                    return moodCell
                }
            case 2:
                if let activityCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ActivityCell.self), for: indexPath) as? ActivityCell {
                    activityCell.selectionStyle = .none
                    activityCell.delegate = self
                    return activityCell
                }
            case 3:
                if let noteCell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteCell.self), for: indexPath) as? NoteCell {
                    noteCell.selectionStyle = .none
                    noteCell.delegate = self
                    return noteCell
                }
                
            default:
                let defaultCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
                return defaultCell
            }
        }
        
        let defaultCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        return defaultCell
        
    }
    
}

extension BPResultVC {
    func keyboardWillShow(_ notification: Notification){
        
        if let userInfo = (notification as NSNotification).userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if let endFrame = endFrame{
                self.bottomConstraint.constant = endFrame.size.height
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    func keyboardWillHide(_ notification: Notification){
        if let userInfo = (notification as NSNotification).userInfo {
            _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            self.bottomConstraint.constant = 70
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

