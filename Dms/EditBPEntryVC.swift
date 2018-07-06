//
//  EditBPEntryVC.swift
//  FTN
//
//  Created by Marko Stajic on 12/23/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

protocol EditResultDelegate: class {
    func returnBpResult(result: BloodPressureReading)
    func resultDeleted()
}

final class EditBPEntryVC: CommonVC, StoryboardInitializable {
    
    weak var delegate : EditResultDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: CustomButton!
    
    var bloodPressureReadingOriginal : BloodPressureReading!
    var bloodPressureReading : BloodPressureReading!
    
    var createdDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bloodPressureReadingOriginal != nil {
            bloodPressureReading = bloodPressureReadingOriginal.copy() as! BloodPressureReading
        }
        
        
        updateViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditBPEntryVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditBPEntryVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: true)

        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]
        //        self.title = NSLocalizedString("general.appname", comment: "")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViews() {
        
        if !bloodPressureReading.validated {
            addDeleteButton()
            addTwoLineNavigationTitle(title: "Edit Manual Reading", subtitle: "Blood Pressure")
        }else{
            addTwoLineNavigationTitle(title: "Edit Reading", subtitle: "Blood Pressure")
        }
        addCancelButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditBPEntryVC.dismissKeyboard))
        tap.delegate = self
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
        tableView.register(UINib(nibName: String(describing: ManualResultCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ManualResultCell.self))
        tableView.register(UINib(nibName: String(describing: ReadingHeaderCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ReadingHeaderCell.self))
        tableView.register(UINib(nibName: String(describing: MoodCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoodCell.self))
        tableView.register(UINib(nibName: String(describing: NoteCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NoteCell.self))
        tableView.register(UINib(nibName: String(describing: ActivityCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ActivityCell.self))
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let placeholderView = touch.view as? PlaceholderView {
            placeholderView.textField.becomeFirstResponder()
            return false
        }else{
            return true
        }
    }
    
    func checkIfBPValid() -> (valid: Bool, message: String) {
        
        if createdDate > Date(){
            return (false, "Date can not be from the future")
        }else if bloodPressureReading.systolic == 0 {
            return (false, "Systolic value must be larger than 0")
        }else if bloodPressureReading.diastolic == 0 {
            return (false, "Diastolic value must be larger than 0")
        }else if bloodPressureReading.heartRate == 0 {
            return (false, "Heart rate value must be larger than 0")
        }else if bloodPressureReading.mood == nil {
            return (false, "Mood is required")
        }else if bloodPressureReading.activity == nil {
            return (false, "Activity is required")
        }else{
            return (true, "Ok")
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        if bloodPressureReading != nil {
            
            let check = checkIfBPValid()
            
            if check.valid {
                startLoading()
                let currentDate = Date()
                var localTimeZoneAbbreviation: String { return TimeZone.current.secondsFromGMT().timezoneOffset() }
                bloodPressureReading.lastUpdated = currentDate.getTimestamp(utcOffset: nil)
                
                DataManager.sharedInstance.editBloodPressureReading(bloodPressureReading: bloodPressureReading!, completion: { (SingleBloodPressureReadingResponse) in
                    self.stopLoading()
                    if SingleBloodPressureReadingResponse.success {
                        
                        self.dismiss(animated: true, completion: {
                            self.bloodPressureReadingOriginal = SingleBloodPressureReadingResponse.bloodPressureReading!
                            self.delegate?.returnBpResult(result: self.bloodPressureReadingOriginal)
                        })
                    }else{
//                        self.showError(errorMessage: "Failed to upload blood pressure reading")
                    }
                })
            }else{
                self.showError(errorMessage: check.message)
            }
            
        }else{
            showError(errorMessage: "Measurement error")
        }
}
    
    override func deleteReading() {
        if bloodPressureReading != nil {
            startLoading()
            
            DataManager.sharedInstance.deleteBloodPressureReading(readingId: bloodPressureReading!.id, completion: { (GeneralResponse) in
                self.stopLoading()
                if GeneralResponse.success {
                    self.dismiss(animated: true, completion: {
                        self.delegate?.resultDeleted()
                    })
                }else{
                    self.showError(errorMessage: GeneralResponse.message)
                }
            })
        }
    }
    
}

extension EditBPEntryVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 301
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let resultCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ManualResultCell.self), for: indexPath) as? ManualResultCell {
                if bloodPressureReading != nil {
                    resultCell.bloodPressureReading = bloodPressureReading
                }
                resultCell.delegate = self
                resultCell.selectionStyle = .none
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
                    if bloodPressureReading != nil {
                        if let mood = bloodPressureReading.mood {
                            moodCell.mood = Mood(rawValue: mood.capitalized) ?? Mood.NoMood
                        }
                    }
                    moodCell.delegate = self
                    return moodCell
                }
            case 2:
                if let activityCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ActivityCell.self), for: indexPath) as? ActivityCell {
                    activityCell.selectionStyle = .none
                    if bloodPressureReading != nil {
                        if let activity = bloodPressureReading.activity {
                            activityCell.activity = ActivityBP(rawValue: activity.capitalized) ?? ActivityBP.noActivity
                        }
                    }
                    activityCell.delegate = self
                    return activityCell
                }
            case 3:
                if let noteCell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteCell.self), for: indexPath) as? NoteCell {
                    noteCell.selectionStyle = .none
                    if bloodPressureReading != nil {
                        noteCell.bpReading = bloodPressureReading
                    }
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

extension EditBPEntryVC : MoodDelegate, ActivityDelegate, NoteDelegate {
    
    func returnMood(mood: Mood?) {
        if bloodPressureReading != nil {
            if let mood = mood {
                bloodPressureReading.mood  = mood.jsonRepresentation
            }else{
                bloodPressureReading.mood = nil
            }
        }
    }
    func returnActivity(activity: ActivityBP?) {
        if bloodPressureReading != nil {
            if activity != nil {
                bloodPressureReading.activity = activity!.jsonRepresentation
            }else{
                bloodPressureReading.activity = nil
            }
        }
    }
    func returnNote(note: String?) {
        if note != "" {
            bloodPressureReading.note = note
        }
    }
    func scrollToBottom() {
        self.tableView.scrollToRow(at: IndexPath(row: 3, section: 1), at: UITableViewScrollPosition.bottom, animated: true)
    }
}

extension EditBPEntryVC {
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

extension EditBPEntryVC : ManuaEntryBloodPressureDelegate {
    func textFieldCheckPassed(_ passed: Bool, systolic: String?, diastolic: String?, hearbeat: String?, date: String?, time: String?) {
        if passed {
            
            guard let sysInt = UInt(systolic!) else {
                showError(errorMessage: "Invalid systolic value")
                return
            }
            
            guard let diaInt = UInt(diastolic!) else {
                showError(errorMessage: "Invalid diastolic value")
                return
                
            }
            
            guard let heartInt = UInt(hearbeat!) else {
                showError(errorMessage: "Invalid heart rate value")
                return
                
            }
            
            guard let date =  date else {
                showError(errorMessage: "Invalid date")
                return
            }
            
            guard let time =  time else {
                showError(errorMessage: "Invalid date")
                return
            }
            
            let completeDateString = date + " " + time
            let completeDate = completeDateString.getCompleteDate()
            
            var localTimeZoneAbbreviation: String { return TimeZone.current.secondsFromGMT().timezoneOffset() }
            
            print("• Complete date string: \(completeDateString)")
            print("• Complete date date: \(completeDate)")
            
            createdDate = completeDate ?? Date()
            bloodPressureReading.timestamp = createdDate.getTimestamp(utcOffset: nil)
            bloodPressureReading.utcOffset = localTimeZoneAbbreviation
            
            bloodPressureReading.systolic = sysInt
            bloodPressureReading.diastolic = diaInt
            bloodPressureReading.heartRate = heartInt
            
            doneButton.setEnabledWithAnimation = true //TODO: Animation enabling big button
        }else{
            doneButton.setEnabledWithAnimation = false //TODO: Animation enabling big button
        }
    }
}
