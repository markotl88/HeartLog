//
//  BPHistoryVC.swift
//  FTN
//
//  Created by Marko Stajic on 12/19/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import BGTableViewRowActionWithImage

protocol BPHistoryDelegate: class {
    func viewControllerPushed()
}

final class BPHistoryVC: CommonVC, StoryboardInitializable {
    
    var isPresented : Bool = true
    let kStartingYear : Int = 2016
    weak var delegate : BPHistoryDelegate?
    var noReadingsInHistory : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var parentIsResultScreen = false
    
    var bloodPressureReadings = [BloodPressureReading]()
    var bpReading : BloodPressureReading!
    
    var newEndDate : Date!
    var graphSection = 0
    var buttonSection = 1
    
    var readingsSections : Dictionary = [Date: [BloodPressureReading]]()
    var readingSortedDays = [Date]()
    
    var emptyTable = false
    
    var tempIndex : IndexPath?
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var blurEffectView : UIVisualEffectView!
    
    var landscapeMode = false
    
    var tempOffset : CGPoint = CGPoint(x: 0, y: 0)
    var currentPeriodToShow : GraphPeriod = GraphPeriod.Week
    
    var previousOrientation = UIDeviceOrientation.portrait
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set Today's midnight as a first date to search to
        updateViews()
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(showBPMeasure))
        plusButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc func showBPMeasure() {
        AppCoordinator.shared.showBPMStartMeasureViewController(viewController: self)
    }
    
    func totalDataReload(){
        bloodPressureReadings.removeAll()
        newEndDate = calendar.date(byAdding: Calendar.Component.day, value: +1, to: Date())
        viewMoreReadings()
    }
    
    override func backToHome() {
        self.isPresented = false
        super.backToHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPresented = true
        
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: true)

        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]

        totalDataReload()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func viewMoreButtonAction(){
        viewMoreReadings()
    }
    
    func viewMoreReadings(){
        startLoading()
        reloadBloodPressureReadings()
    }
    
    func reloadBloodPressureReadings(){
        
        let endDate : Date = newEndDate
        let startDate = self.getStartDate(interval: 7, endDate: endDate)
        self.newEndDate = startDate

        let bpReadings = DataManager.sharedInstance.getBloodPressureReadingsFromDateToDate(startDate: startDate, endDate: endDate)
        if bpReadings.count == 0 {
            
            if bloodPressureReadings.count == 0 {
                emptyTable = true
                buttonSection = 1
                stopLoading()
                self.noReadingsInHistory = true
                self.tableView.reloadData()
//                self.showError(errorMessage: "No readings in history")

            }else{
                self.noReadingsInHistory = false
                let calendar = Calendar.current
                let startDateYear = calendar.component(Calendar.Component.year, from: startDate)
                if startDateYear < kStartingYear {
                    stopLoading()
                    noMoreReadings = true
                    self.tableView.reloadData()
//                    self.showError(errorMessage: "No more readings")
                }else{
                    reloadBloodPressureReadings()
                }
            }
            
        }else{
            emptyTable = false
            stopLoading()
            
            print("\nAppending fetched readings to Readings list")
            let methodStart = Date()
            for bp in bpReadings {
                self.bloodPressureReadings.append(bp)
            }
            let methodFinish = Date()
            let executionTime = methodFinish.timeIntervalSince(methodStart)
            print("Execution time: \(executionTime)")

            
            getDataIntoSections()
        }
    }
    func getDataIntoSections(){
        
        readingsSections.removeAll()
        readingSortedDays.removeAll()
        
        for reading in bloodPressureReadings {
            
            if let createdDate = self.cutDateToUTCMidnight(dateToCut: reading.dateCreated) {
                
                print("• To create: \(reading.dateCreated) Created date: \(createdDate) UTC OFF: \(reading.utcOffset)")
                
                var eventsOnThisDay = self.readingsSections[createdDate]
                if eventsOnThisDay == nil {
                    eventsOnThisDay = [BloodPressureReading]()
                    readingSortedDays.append(createdDate)
                }
                eventsOnThisDay?.append(reading)
                eventsOnThisDay = eventsOnThisDay?.sorted(by: { $0.dateCreated.compare($1.dateCreated) == ComparisonResult.orderedDescending })
                self.readingsSections[createdDate] = eventsOnThisDay
            }
        }
        
        print("\nSort Readings days list")
        readingSortedDays = readingSortedDays.sorted(by: { $0.compare($1) == ComparisonResult.orderedDescending })
        
//        fillAverageValuesArray()
        startReloadingTable()

    }

    func startReloadingTable(){
        
        self.buttonSection = readingsSections.count + 1
        self.tableView.reloadData()
    }
    
    func updateViews() {
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        addTwoLineNavigationTitle(title: "Blood Pressure", subtitle: "Trends by Date")
        addAddEntryButton()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]
        //        self.title = NSLocalizedString("general.appname", comment: "")
        
        tableView.backgroundColor = UIColor.dmsPaleGrey
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 173
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing: HistoryResultCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HistoryResultCell.self))
        tableView.register(UINib(nibName: String(describing: ViewMoreCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ViewMoreCell.self))
        tableView.register(UINib(nibName: String(describing: GraphTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: GraphTableCell.self))
        tableView.register(UINib(nibName: String(describing: GraphTableCellLandscape.self), bundle: nil), forCellReuseIdentifier: String(describing: GraphTableCellLandscape.self))
    }
    
    func editResult(indexPath: IndexPath) {
        
        let representingDay = self.readingSortedDays[indexPath.section-1]
        let recordings = self.readingsSections[representingDay]! as [BloodPressureReading]
        self.bpReading = recordings[indexPath.row]
        tempIndex = indexPath
        self.tableView.setEditing(false, animated: true)
        
        AppCoordinator.shared.showEditBPViewController(viewController: self, reading: self.bpReading)
    }
    
    func showResult(reading: BloodPressureReading) {
        tempOffset = tableView.contentOffset
        let historyResult = HistoryResultVC()
        self.view.addSubview(blurEffectView)
        historyResult.delegate = self
        self.present(historyResult, animated: true, completion: nil)
        self.isPresented = false
        DispatchQueue.main.async {
            historyResult.bloodPressureReading = reading
        }
    }
    
}

extension BPHistoryVC : SingleResultDelegate {
    func deletedResult() {
        self.isPresented = true
        blurEffectView.removeFromSuperview()
        totalDataReload()
        
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
        if let graphCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GraphTableCell {
            graphCell.daysToShow = currentPeriodToShow
        }
    }
    func resultEdited(result: BloodPressureReading) {
        if let indexToRefresh = tempIndex{
            
            let representingDay = self.readingSortedDays[indexToRefresh.section-1]
            readingsSections[representingDay]?[indexToRefresh.row] = result
            
            if let reading = bloodPressureReadings.filter({$0.id == result.id}).first {
                if let index = bloodPressureReadings.index(of: reading) {
                    bloodPressureReadings[index] = result
                }
            }
            tableView.reloadRows(at: [indexToRefresh], with: .fade)
        }

    }
    func resultClosed() {
        blurEffectView.removeFromSuperview()
        isPresented = true
    }

}
extension BPHistoryVC : EditResultDelegate {
    func returnBpResult(result: BloodPressureReading) {
        if let indexToRefresh = tempIndex {
            let representingDay = self.readingSortedDays[indexToRefresh.section-1]
            readingsSections[representingDay]?[indexToRefresh.row] = result
            
            if let reading = bloodPressureReadings.filter({$0.id == result.id}).first {
                if let index = bloodPressureReadings.index(of: reading) {
                    bloodPressureReadings[index] = result
                }
            }
            tableView.reloadRows(at: [indexToRefresh], with: .fade)
        }
    }
    func resultDeleted() {
        totalDataReload()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
        if let graphCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GraphTableCell {
            graphCell.daysToShow = currentPeriodToShow
        }
    }
}
extension BPHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case graphSection:
            return 1
        case buttonSection:
            if noMoreReadings {
                return 0
            }else{
                return 1
            }
        default:
            return readingsSections[readingSortedDays[section-1]]?.count ?? 0
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if landscapeMode {
            return 1
        }else{
            if emptyTable {
                return 2
            }else{
                return readingsSections.count + 2
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if landscapeMode {
            if indexPath.section == graphSection {
                return UIScreen.main.bounds.height
            }else{
                return UITableViewAutomaticDimension
            }
        }else{
            
            if indexPath.section == buttonSection {
                return 71
            }else{
                return UITableViewAutomaticDimension
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case graphSection:
            return 1
        case 1:
            return 87
        case buttonSection:
            return 1
        default:
            return 48
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
        case graphSection:
            return 1
        case buttonSection:
            return 1
        default:
            return 2
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2.0))
        footerView.backgroundColor = UIColor.dmsCloudyBlueTwo
        footerView.layer.shadowColor = UIColor.dmsCloudyBlueTwo.cgColor
        footerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        footerView.layer.shadowOpacity = 1
        footerView.layer.shadowRadius = 1.0
        return footerView
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            
            
        case 0:
            return nil
            
        case 1:
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 87))
            let activityLabel = ActivityLabel(frame: CGRect(x: 15, y: 23, width: UIScreen.main.bounds.width - 30, height: 29))
            activityLabel.text = "Reading history".uppercased()
            headerView.addSubview(activityLabel)
            
            let dateLabel = CheckBoxLabel(frame: CGRect(x: 15, y: 57, width: UIScreen.main.bounds.width - 30, height: 20))
            print("Reading section count: \(readingSortedDays.count)")
            if readingSortedDays.count != 0 {
                dateLabel.text = readingSortedDays[section-1].getLocalShortDate()
            }
            headerView.addSubview(dateLabel)
            headerView.backgroundColor = UIColor.dmsPaleGrey

            return headerView
            
        case buttonSection:
            return nil
            
        default:
            let headerDateView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48))
            let dateLabel = CheckBoxLabel(frame: CGRect(x: 15, y: 18, width: UIScreen.main.bounds.width - 30, height: 20))
            dateLabel.text =  readingSortedDays[section-1].getLocalShortDate()
            headerDateView.addSubview(dateLabel)
            headerDateView.backgroundColor = UIColor.dmsPaleGrey
            return headerDateView
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section != 0 && indexPath.section != buttonSection {
            return true
        }else{
            return false
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editButton = BGTableViewRowActionWithImage.rowAction(with: UITableViewRowActionStyle.default, title: "Edit", backgroundColor: UIColor.dmsViridian, image: #imageLiteral(resourceName: "iconSwipeEdit"), forCellHeight: 173) { (action, indexPath) in
            
            if let indexPath = indexPath {
                self.editResult(indexPath: indexPath)
            }
        }
        return [editButton!]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case graphSection:
            
            if landscapeMode {
                
                if let graphCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GraphTableCellLandscape.self), for: indexPath) as? GraphTableCellLandscape {
                    if noReadingsInHistory {
                        graphCell.emptyGraphView.isHidden = false
                    }else{
                        graphCell.emptyGraphView.isHidden = true
                    }
                    graphCell.emptyTable = self.emptyTable
                    graphCell.selectionStyle = .none
                    graphCell.delegate = self
                    return graphCell
                }

            }else{
                if let graphCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GraphTableCell.self), for: indexPath) as? GraphTableCell {
                    if noReadingsInHistory {
                        graphCell.emptyGraphView.isHidden = false
                    }else{
                        graphCell.emptyGraphView.isHidden = true
                    }
                    graphCell.emptyTable = self.emptyTable
                    graphCell.selectionStyle = .none
                    graphCell.delegate = self
                    return graphCell
                }
            }
        case buttonSection:
            if let buttonCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ViewMoreCell.self), for: indexPath) as? ViewMoreCell {
                buttonCell.selectionStyle = .none
                buttonCell.viewMoreButton.addTarget(self, action: #selector(BPHistoryVC.viewMoreReadings), for: UIControlEvents.touchUpInside)
                return buttonCell
            }
        default:
            if let resultCell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistoryResultCell.self), for: indexPath) as? HistoryResultCell {
                
                let representingDay = self.readingSortedDays[indexPath.section-1]
                var recordings = self.readingsSections[representingDay]! as [BloodPressureReading]
                recordings = recordings.sorted(by: {$0.dateCreated > $1.dateCreated})
                resultCell.bloodPressureReading = recordings[indexPath.row]
                resultCell.selectionStyle = .none
                return resultCell
            }
        }
        
        let defaultCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        return defaultCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != 0 && indexPath.section != buttonSection {

            tempIndex = indexPath
            let representingDay = self.readingSortedDays[indexPath.section-1]
            var recordings = self.readingsSections[representingDay]! as [BloodPressureReading]
            recordings = recordings.sorted(by: {$0.dateCreated > $1.dateCreated})
            let record = recordings[indexPath.row]
            showResult(reading: record)
        }
    }
}

extension BPHistoryVC : GraphPeriodDelegate {
    func returnGraphPeriod(daysToShow: GraphPeriod) {
        self.currentPeriodToShow = daysToShow
    }
}
