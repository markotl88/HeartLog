//
//  GraphTableCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/26/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

protocol GraphPeriodDelegate: class {
    func returnGraphPeriod(daysToShow: GraphPeriod)
}

class GraphTableCell: UITableViewCell {
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var systolicDotImage: UIView!
    @IBOutlet weak var diastolicDotImage: UIView!
    @IBOutlet weak var systolicLabel: CellTitle!
    @IBOutlet weak var diastolicLabel: CellTitle!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var emptyGraphView: UIView!
    
    fileprivate var chart: Chart? // arc
    let calendar = Calendar.current
    
    var bloodPressureReadingsToShow = [BloodPressureReading]()
    
    //Chart settings
    var iPhoneChartSettings: ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = -10
        chartSettings.top = 15
        chartSettings.trailing = 0
        chartSettings.bottom = -15
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        return chartSettings
    }
    
    //Tuple where the first element is array of systolic averages, and second element is array of diastolic averages for every day in chosen period
    var bloodPressureGraphArray : BloodPressureGraphResults! {
        didSet {
            updateChartWithData(array: bloodPressureGraphArray)
        }
    }
    
    var xValues = [ChartAxisValue]()
    weak var delegate : GraphPeriodDelegate?
    
    var readingsSections : Dictionary = [Date: [BloodPressureReading]]()
    var readingSortedDays = [Date]()
    
    var systolicGraphData = [GraphData]()
    var diastolicGraphData = [GraphData]()
    var heartrateGraphData = [GraphData]()
    
    var chartPointsSystolicMax = [ChartPoint]()
    var chartPointsDiastolicMax = [ChartPoint]()
    
    var chartPointsSysCom = [ChartPoint]()
    var chartPointsDiaCom = [ChartPoint]()

    var emptyTable : Bool = false {
        didSet {
            if emptyTable == true {
                self.chart?.view.removeFromSuperview()
                emptyTable = false
            }
        }
    }
    
    var daysToShow : GraphPeriod = GraphPeriod.Week {
        didSet {
            delegate?.returnGraphPeriod(daysToShow: self.daysToShow)
            getBloodPressureReadignsForPeriod(self.daysToShow)
            selectGraphPeriodCollectionCell(daysToShow: self.daysToShow)
        }
    }
    
    func selectGraphPeriodCollectionCell(daysToShow: GraphPeriod){
        switch daysToShow {
        case .Week:
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = true
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
        case .TwoWeeks:
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = true
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
        case .Month:
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = true
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
        case .ThreeMonths:
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = false
            }
            if let periodCell = self.collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? PeriodCollectionCell {
                periodCell.selectedCell = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        systolicLabel.textColor = UIColor.dmsPineGreen
        diastolicLabel.textColor = UIColor.dmsPineGreen
        systolicLabel.updateFont(size: 14.0)
        diastolicLabel.updateFont(size: 14.0)
        
        systolicDotImage.layer.borderColor = UIColor.dmsPineGreen.cgColor
        systolicDotImage.layer.borderWidth = 3.0
        diastolicDotImage.layer.borderColor = UIColor.dmsMango.cgColor
        diastolicDotImage.layer.borderWidth = 3.0
        systolicDotImage.layer.cornerRadius = 6.0
        diastolicDotImage.layer.cornerRadius = 6.0
        
        systolicDotImage.backgroundColor = UIColor.clear
        diastolicDotImage.backgroundColor = UIColor.clear
        separatorView.backgroundColor = UIColor.dmsPaleGrey
        
//        scrollView.bounces = true
//        scrollView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: PeriodCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PeriodCollectionCell.self))
        
//        getBloodPressureReadignsForPeriod(daysToShow)
        daysToShow = GraphPeriod.Week
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GraphTableCell.swipeAction(gesture:)))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GraphTableCell.swipeAction(gesture:)))
        rightSwipe.direction = .right

        self.contentView.addGestureRecognizer(leftSwipe)
        self.contentView.addGestureRecognizer(rightSwipe)
       
    }
    func swipeAction(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .left {
            switch daysToShow {
            case .Week:
                self.daysToShow = .TwoWeeks
            case .TwoWeeks:
                self.daysToShow = .Month
            case .Month:
                self.daysToShow = .ThreeMonths
            case .ThreeMonths:
                self.daysToShow = .Week
            }
        }else if gesture.direction == .right {
            switch daysToShow {
            case .Week:
                self.daysToShow = .ThreeMonths
            case .TwoWeeks:
                self.daysToShow = .Week
            case .Month:
                self.daysToShow = .TwoWeeks
            case .ThreeMonths:
                self.daysToShow = .Month
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//Plotting graph data functions
extension GraphTableCell {
    func fillXValuesArray(period: GraphPeriod){
        
        let readFormatter = DateFormatter()
        readFormatter.dateFormat = "MM/dd/yyyy"
        
        let displayFormatterNewMonth = DateFormatter()
        displayFormatterNewMonth.dateFormat = "MMM dd"
        
        xValues.removeAll()
        var endDate = calendar.date(byAdding: Calendar.Component.day, value: +1, to: Date()) ?? Date() //Date()
        var pastDate = Date()
        xValues.append(createDateAxisValue(isFirstOrLast: true, dateStr: self.getGraphString(date: endDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
        
        switch period {
        case .Week:
            let daysInterval = -1
            for i in 0..<period.daysToShowOnX {
                pastDate = calendar.date(byAdding: Calendar.Component.day, value: daysInterval, to: endDate) ?? Date()
                if i == period.daysToShowOnX-1 {
                    xValues.append(createDateAxisValue(isFirstOrLast: true, dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
                }else{
                    xValues.append(createDateAxisValue(dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
                }
                endDate = pastDate
            }
            
        case .TwoWeeks:
            let daysInterval = -2
            
            endDate = Date()
            xValues.append(createDateAxisValue(dateStr: self.getGraphString(date: endDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
            for _ in 0..<period.daysToShowOnX {
                pastDate = calendar.date(byAdding: Calendar.Component.day, value: daysInterval, to: endDate) ?? Date()
                xValues.append(createDateAxisValue(dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
                endDate = pastDate
            }
            pastDate = calendar.date(byAdding: Calendar.Component.day, value: -1, to: endDate) ?? Date()
            xValues.append(createDateAxisValue(isFirstOrLast: true, dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
            
        case .Month:
            let monthInterval = -1
            let dateInterval = -15
            
            endDate = Date()
            xValues.append(createDateAxisValue(dateStr: self.getGraphString(date: endDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
            
            pastDate = calendar.date(byAdding: Calendar.Component.day, value: dateInterval, to: endDate) ?? Date()
            xValues.append(createDateAxisValue(dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
            
            pastDate = calendar.date(byAdding: Calendar.Component.month, value: monthInterval, to: endDate) ?? Date()
            xValues.append(createDateAxisValue(dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
            endDate = pastDate
            
            pastDate = calendar.date(byAdding: Calendar.Component.day, value: -1, to: endDate) ?? Date()
            xValues.append(createDateAxisValue(isFirstOrLast: true, dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
            
        case .ThreeMonths:
            
            let dateInterval = -1
            endDate = Date()
            xValues.append(createDateAxisValue(dateStr: self.getGraphString(date: endDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
            for _ in 0..<period.daysToShowOnX {
                pastDate = calendar.date(byAdding: Calendar.Component.month, value: dateInterval, to: endDate) ?? Date()
                xValues.append(createDateAxisValue(dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
                endDate = pastDate
            }
            pastDate = calendar.date(byAdding: Calendar.Component.day, value: -1, to: endDate) ?? Date()
            xValues.append(createDateAxisValue(isFirstOrLast: true, dateStr: self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatterNewMonth))
        }
        //Prazan string za prvi i poslednji datum
        xValues = xValues.reversed()
        
    }
}

//Graph helper functions
extension GraphTableCell {
    
    func getGraphString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    func cutDateToMidnight(dateToCut: Date) -> Date?{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return df.date(from: df.string(from: dateToCut))
    }
    func getMinAndMaxYValues(systolicData: [GraphData], diastolicData: [GraphData]) -> (min: UInt, max: UInt) {
        
        var maxPress : (Double, Double) = (0, 0)
        var minPress = (Double(UInt.max), Double(UInt.max))

        for sysReading in systolicData {
            if let sysMax = sysReading.maximum {
                if sysMax > maxPress.0 {
                    maxPress.0 = sysMax
                }
            }
            if let sysMin = sysReading.minimum {
                if sysMin < minPress.0 {
                    minPress.0 = sysMin
                }
            }
        }
        
        for diaReading in diastolicData {
            if let diaMax = diaReading.maximum {
                if diaMax > maxPress.1 {
                    maxPress.1 = diaMax
                }
            }
            if let diaMin = diaReading.minimum {
                if diaMin < minPress.1 {
                    minPress.1 = diaMin
                }
            }
        }
        
        
        var maxY : UInt!
        var minY : UInt!
        
        if UInt(floor((minPress.1/10)))%2 == 1 {
            
            if minPress.1 != Double(UInt.max) {
                minY = UInt(floor(minPress.1/10))*10
            }else{
                minY = 0
            }
            if UInt(floor(maxPress.0/10))%2 == 1 {
                maxY = (UInt(floor(maxPress.0/10))+2)*10
            }else{
                maxY = (UInt(floor(maxPress.0/10))+1)*10
            }
            
        }else{
            
            if minPress.1 != Double(UInt.max) {
                minY = UInt(floor(minPress.1/10))*10
            }else{
                minY = 0
            }
            if UInt(floor(maxPress.0/10))%2 == 1 {
                maxY = (UInt(floor(maxPress.0/10))+1)*10
            }else{
                maxY = (UInt(floor(maxPress.0/10))+2)*10
            }
        }
        
        if maxY >= 300 {
            maxY = ((maxY/50)+1)*50
            minY = 0
            return (min: minY, max: maxY)
        }else{
            return (min: minY, max: maxY)
        }
    }
    func createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: String, y: Double, numberOfReadings: Int, isLast: Bool, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartPoint {
        return ChartPoint(x: self.createDateAxisValue(dateStr: dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter), y: ChartAxisValueDouble(y), numberOfReadings: numberOfReadings, isLast: isLast, dateStr: dateStr)
    }
    func createDateAxisValue(isFirstOrLast: Bool = false, dateStr: String, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartAxisValue {
        
        let date = readFormatter.date(from: dateStr)!
        let labelSettings : ChartLabelSettings!
        
        switch daysToShow {
        case .Week:
            labelSettings = ChartLabelSettings(font: UIFont(name: Font.GothamMedium, size: 9.0)!, rotation: 0.0, rotationKeep: .top)
        case .TwoWeeks:
            labelSettings = ChartLabelSettings(font: UIFont(name: Font.GothamMedium, size: 9.0)!, rotation: 0.0, rotationKeep: .top)
        case .Month:
            labelSettings = ChartLabelSettings(font: UIFont(name: Font.GothamMedium, size: 12.0)!, rotation: 0.0, rotationKeep: .top)
        case .ThreeMonths:
            labelSettings = ChartLabelSettings(font: UIFont(name: Font.GothamMedium, size: 12.0)!, rotation: 0.0, rotationKeep: .top)
        }
        
        if isFirstOrLast {
            return ChartAxisValueDate(isFirstOrLast: true, date: date, formatter: displayFormatter, labelSettings: labelSettings)
        }else{
            return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
        }
    }
}

extension GraphTableCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let periodCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PeriodCollectionCell.self), for: indexPath) as? PeriodCollectionCell {
            periodCell.periodLabel.text = GraphPeriod(rawValue: indexPath.row)?.description
            if indexPath.row == self.daysToShow.rawValue {
                periodCell.selectedCell = true
            }else{
                periodCell.selectedCell = false
            }
            return periodCell
        }
        
        let defaultCell = UICollectionViewCell() //(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        return defaultCell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.daysToShow = GraphPeriod(rawValue: indexPath.row) ?? GraphPeriod.Week
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let periodCell = collectionView.cellForItem(at: indexPath) as? PeriodCollectionCell {
            periodCell.selectedCell = false
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: UIScreen.main.bounds.width/4.0, height: 50.0)
        return cellSize
    }
}

extension GraphTableCell {
    func getBloodPressureReadignsForPeriod(_ period: GraphPeriod){
        
        bloodPressureReadingsToShow.removeAll()
        
        let endDate : Date = Date()
        var startDate : Date = Date()
        
        let calendar = Calendar.current
        
        switch period {
        case .Week:
            startDate = self.cutDateToMidnight(dateToCut: calendar.date(byAdding: Calendar.Component.day, value: -7, to: Date())  ?? Date()) ?? Date() //Date()
            print("• Start date week: \(startDate)")
            print("• End date: \(endDate)")
            
        case .TwoWeeks:
            startDate = self.cutDateToMidnight(dateToCut: calendar.date(byAdding: Calendar.Component.day, value: -14, to: Date())  ?? Date()) ?? Date() //Date()
//            print("Start date 2 weeks: \(startDate)")
            
        case .Month:
            startDate = self.cutDateToMidnight(dateToCut: calendar.date(byAdding: Calendar.Component.month, value: -1, to: Date())  ?? Date()) ?? Date() //Date()
//            print("Start date month: \(startDate)")
            
        case .ThreeMonths:
            startDate = self.cutDateToMidnight(dateToCut: calendar.date(byAdding: Calendar.Component.month, value: -3, to: Date())  ?? Date()) ?? Date() //Date()
//            print("Start date 3 months: \(startDate)")
        }
        
        let bpReadings = DataManager.sharedInstance.getBloodPressureReadingsFromDateToDate(startDate: startDate, endDate: endDate)
        
//        print("BP READINGS FROM CORE DATA: \(bpReadings.count)")
        if bpReadings.count != 0 {
            emptyGraphView.isHidden = true
            for reading in bpReadings {
                self.bloodPressureReadingsToShow.append(reading)
            }
            getDataIntoSections()
        }else{
            self.chart?.view.removeFromSuperview()
            emptyGraphView.isHidden = false
        }
    }
    func getDataIntoSections(){
        
        readingsSections.removeAll()
        readingSortedDays.removeAll()
        
        for reading in bloodPressureReadingsToShow {
            if let createdDate = self.cutDateToUTCMidnight(dateToCut: reading.dateCreated)  {
                
                var eventsOnThisDay = self.readingsSections[createdDate]
                if eventsOnThisDay == nil {
                    eventsOnThisDay = [BloodPressureReading]()
                    readingSortedDays.append(createdDate)
                }
                eventsOnThisDay?.append(reading)
//                eventsOnThisDay = eventsOnThisDay?.sorted(by: { $0.dateCreated.compare($1.dateCreated) == ComparisonResult.orderedDescending })
                self.readingsSections[createdDate] = eventsOnThisDay
            }
        }
        
        readingSortedDays = readingSortedDays.sorted(by: { $0.compare($1) == ComparisonResult.orderedDescending })
        fillGraphValues()
    }
    func fillGraphValues(){
        
        var systolicValues = [Double]()
        var diastolicValues = [Double]()
        var heartrateValues = [Double]()
        
        systolicGraphData.removeAll()
        diastolicGraphData.removeAll()
        heartrateGraphData.removeAll()
        
        print("•••••••••••••••••••••••••")
        print("Reading sections BP: \(readingsSections)")
        print("•••••••••••••••••••••••••")

        for (_, readings) in readingsSections {
            //            print("\nDate: \(date)")
            systolicValues.removeAll()
            diastolicValues.removeAll()
            heartrateValues.removeAll()

            _ = readings.first?.dateCreated.getGraphDate(utcOffset: nil) ?? Date().getGraphDate(utcOffset: nil) ?? ""
            //            print("Real date: \(realDate)")
            let dateCreated = readings.first?.dateCreated ?? Date()
            
            for reading in readings {
                systolicValues.append(Double(reading.systolic))
                diastolicValues.append(Double(reading.diastolic))
                heartrateValues.append(Double(reading.heartRate))
            }
            
            let systolicSum = systolicValues.reduce(0, +)
            let diastolicSum = diastolicValues.reduce(0, +)
            let heartrateSum = heartrateValues.reduce(0, +)

            let systolicAverage = systolicSum/Double(systolicValues.count)
            let diastolicAverage = diastolicSum/Double(diastolicValues.count)
            let heartrateAverage = heartrateSum/Double(heartrateValues.count)

            systolicGraphData.append(GraphData(date: dateCreated, values: systolicValues, countOfReadings: systolicValues.count, average: systolicAverage, minimum: systolicValues.min(), maximum: systolicValues.max()))
            diastolicGraphData.append(GraphData(date: dateCreated, values: diastolicValues, countOfReadings: diastolicValues.count, average: diastolicAverage, minimum: diastolicValues.min(), maximum: diastolicValues.max()))
            heartrateGraphData.append(GraphData(date: dateCreated, values: heartrateValues, countOfReadings: heartrateValues.count, average: heartrateAverage, minimum: heartrateValues.min(), maximum: heartrateValues.max()))
        }
        
        systolicGraphData = systolicGraphData.sorted(by: { (lhs: GraphData, rhs: GraphData) -> Bool in
            return lhs.date < rhs.date
        })
        diastolicGraphData = diastolicGraphData.sorted(by: { (lhs: GraphData, rhs: GraphData) -> Bool in
            return lhs.date < rhs.date
        })
        heartrateGraphData = heartrateGraphData.sorted(by: { (lhs: GraphData, rhs: GraphData) -> Bool in
            return lhs.date < rhs.date
        })
        
        bloodPressureGraphArray = BloodPressureGraphResults(systolicGraphData, diastolicGraphData)
    }
}

extension GraphTableCell {
    func updateChartWithData(array: BloodPressureGraphResults) {
        self.chart?.view.removeFromSuperview()
        self.chart?.view.clipsToBounds = false
        
        chartPointsDiaCom.removeAll()
        chartPointsSysCom.removeAll()
        
        chartPointsSystolicMax.removeAll()
        chartPointsDiastolicMax.removeAll()
        
        let labelSettings = ChartLabelSettings(font: UIFont(name: Font.GothamBold, size: 12.0)!)
        
        var readFormatter = DateFormatter()
        readFormatter.dateFormat = "MM/dd/yyyy"
//
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd.MM.yyyy"
//
        let date = {(str: String) -> Date in
            return readFormatter.date(from: str)!
        }

        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            return self.calendar.date(from: components)!
        }
        
        func filler(_ date: Date) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        
        let systolicArray = array.systolic
        let diastolicArray = array.diastolic
        
        var lastObject = systolicArray.last
        for (index,i) in systolicArray.enumerated() {
            
            if let lo = lastObject, index == systolicArray.count-1 {
                
                chartPointsSystolicMax.append(createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: self.getGraphString(date: i.date), y: i.maximum ?? i.average, numberOfReadings: i.countOfReadings, isLast: true, readFormatter: readFormatter, displayFormatter: displayFormatter))

                for j in i.values {
                    chartPointsSysCom.append(createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: self.getGraphString(date: i.date), y: j, numberOfReadings: i.countOfReadings, isLast: true, readFormatter: readFormatter, displayFormatter: displayFormatter))
                }

            }else{
                
                chartPointsSystolicMax.append(createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: self.getGraphString(date: i.date), y: i.maximum ?? i.average, numberOfReadings: i.countOfReadings, isLast: true, readFormatter: readFormatter, displayFormatter: displayFormatter))
                
                for j in i.values {
                    chartPointsSysCom.append(createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: self.getGraphString(date: i.date), y: j, numberOfReadings: i.countOfReadings, isLast: false, readFormatter: readFormatter, displayFormatter: displayFormatter))
                }
            }
            
        }
        
        
        lastObject = diastolicArray.last
        for (index,i) in diastolicArray.enumerated() {
            
            if let lo = lastObject, index == diastolicArray.count-1 {

                chartPointsDiastolicMax.append(createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: self.getGraphString(date: i.date), y: i.maximum ?? i.average, numberOfReadings: i.countOfReadings, isLast: true, readFormatter: readFormatter, displayFormatter: displayFormatter))

                for j in i.values {
                    chartPointsDiaCom.append(createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: self.getGraphString(date: i.date), y: j, numberOfReadings: i.countOfReadings, isLast: true, readFormatter: readFormatter, displayFormatter: displayFormatter))
                }

            }else{
                
                chartPointsDiastolicMax.append(createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: self.getGraphString(date: i.date), y: i.maximum ?? i.average, numberOfReadings: i.countOfReadings, isLast: true, readFormatter: readFormatter, displayFormatter: displayFormatter))

                for j in i.values {
                    chartPointsDiaCom.append(createChartPointWithReadingsCountAndIsLastPointInfo(dateStr: self.getGraphString(date: i.date), y: j, numberOfReadings: i.countOfReadings, isLast: false, readFormatter: readFormatter, displayFormatter: displayFormatter))
                }
            }
        }
        
        fillXValuesArray(period: daysToShow)
        let yValueSpan = getMinAndMaxYValues(systolicData: array.systolic, diastolicData: array.diastolic)
        var yValues : [ChartAxisValueDouble]!
        if yValueSpan.max >= 300 {
            yValues = stride(from: yValueSpan.min, through: yValueSpan.max, by: 50).map {ChartAxisValueDouble(Double($0), unit: "\nmmHg", labelSettings: labelSettings)}
        }else{
            yValues = stride(from: yValueSpan.min, through: yValueSpan.max, by: 20).map {ChartAxisValueDouble(Double($0), unit: "\nmmHg", labelSettings: labelSettings)}
        }
        
        if daysToShow == .Month || daysToShow == .ThreeMonths {
            GlobalGraph.minimum = Int(yValueSpan.min)
        }else{
            GlobalGraph.minimum = -10
        }
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings.defaultVertical()))
        let scrollViewFrame = scrollView.frame
        
        var chartFrame = CGRect()
        let chartSettings = self.iPhoneChartSettings
        
        switch daysToShow {
        case .Week:
            chartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: scrollViewFrame.size.height)
            chartSettings.trailing = -7
        case .TwoWeeks:
            chartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: scrollViewFrame.size.height)
            chartSettings.trailing = -1
        case .Month:
            chartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: scrollViewFrame.size.height)
            chartSettings.trailing = 11
        case .ThreeMonths:
            chartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: scrollViewFrame.size.height)
            chartSettings.trailing = 18
        }
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let c0 = UIColor.dmsMetallicBlue.withAlphaComponent(0.7)
        let c1 = UIColor.dmsMango.withAlphaComponent(0.7)
        
        //        let chartPointsLayer0 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPointsSys, areaColor: c0, animDuration: 3, animDelay: 0, addContainerPoints: true)
        //        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPointsDia, areaColor: c1, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        let lineModel0 = ChartLineModel(chartPoints: chartPointsSystolicMax, lineColor: UIColor.dmsMetallicBlue, lineWidth: 2.0, animDuration: 1, animDelay: 0)
        let lineModel1 = ChartLineModel(chartPoints: chartPointsDiastolicMax, lineColor: UIColor.dmsMango, lineWidth: 2.0, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel0, lineModel1])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.dmsMetallicBlue, linesWidth: 0.5)
        let guidelinesLayer = ChartGuideLinesLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, axis: ChartGuideLinesLayerAxis.y, settings: settings, onlyVisibleX: false, onlyVisibleY: true)
        
        var popups: [UIView] = []
        
        var selectedViewMonthly: ChartPointMonthlyView?
        var selectedViewAverage: ChartPointAverageView?
        var selectedViewSmallSingle: ChartPointSmallSingleView?
        var selectedView: ChartPointSingleReadingView? //ChartPointTextCircleView?
        
        let circleViewGenerator = {(color: UIColor, chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            
            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
            
            switch self.daysToShow {
            case .Week:
                if let isLast = chartPoint.last, isLast == false { //noOfReadingsCount = chartPoint.numberOfReadings, noOfReadingsCount != 1 {
                    
                        let v = ChartPointSmallSingleView(chartPoint: chartPoint, center: screenLoc, diameter: 12, borderWidth: 3, color: color)
                        v.viewTapped = {view in
                            for p in popups {p.removeFromSuperview()}
                            
                            func showLabel(view: ChartPointSmallSingleView){
                                selectedViewSmallSingle?.selected = false
                                
                                let w: CGFloat = 150
                                let h: CGFloat = 80
                                
                                let x: CGFloat = {
                                    let attempt = screenLoc.x - (w/2)
                                    let leftBound: CGFloat = chart.bounds.origin.x
                                    let rightBound = chart.bounds.size.width - 5
                                    if attempt < leftBound {
                                        return view.frame.origin.x
                                    } else if attempt + w > rightBound {
                                        return rightBound - w
                                    }
                                    return attempt
                                }()
                                
                                let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
                                
                                let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
                                chart.addSubview(bubbleView)
                                
                                bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
                                let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
                                infoView.textColor = UIColor.white
                                infoView.numberOfLines = 0
                                infoView.backgroundColor = color
                                infoView.text = self.getPopUpString(chartPoint: chartPoint, unit: "mmHg")
                                infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
                                infoView.textAlignment = NSTextAlignment.center
                                
                                bubbleView.addSubview(infoView)
                                popups.append(bubbleView)
                                
                                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                                    
                                    view.selected = true
                                    selectedViewSmallSingle = view
                                    
                                    bubbleView.transform = CGAffineTransform.identity
                                }, completion: {finished in})
                            }
                            
                            if v == selectedViewSmallSingle {
                                if v.selected == true {
                                    selectedViewSmallSingle?.selected = false
                                }else{
                                    showLabel(view: view)
                                }
                            }else{
                                showLabel(view: view)
                            }
                        }
                        return v
                    

                }else{
                
                    let v = ChartPointSingleReadingView(chartPoint: chartPoint, center: screenLoc, diameter: 22, borderWidth: 3, color: color)
                    v.viewTapped = {view in
                        for p in popups {p.removeFromSuperview()}
                        
                        func showLabel(view: ChartPointSingleReadingView){
                            selectedView?.selected = false
                            
                            let w: CGFloat = 150
                            let h: CGFloat = 80
                            
                            let x: CGFloat = {
                                let attempt = screenLoc.x - (w/2)
                                let leftBound: CGFloat = chart.bounds.origin.x
                                let rightBound = chart.bounds.size.width - 5
                                if attempt < leftBound {
                                    return view.frame.origin.x
                                } else if attempt + w > rightBound {
                                    return rightBound - w
                                }
                                return attempt
                            }()
                            
                            let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
                            
                            let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
                            chart.addSubview(bubbleView)
                            
                            bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
                            let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
                            infoView.textColor = UIColor.white
                            infoView.backgroundColor = color
                            infoView.numberOfLines = 0
                            infoView.text = self.getPopUpString(chartPoint: chartPoint, unit: "mmHg")
                            infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
                            infoView.textAlignment = NSTextAlignment.center
                            
                            bubbleView.addSubview(infoView)
                            popups.append(bubbleView)
                            
                            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                                
                                view.selected = true
                                selectedView = view
                                
                                bubbleView.transform = CGAffineTransform.identity
                            }, completion: {finished in})
                        }
                        
                        if v == selectedView {
                            if v.selected == true {
                                selectedView?.selected = false
                            }else{
                                showLabel(view: view)
                            }
                        }else{
                            showLabel(view: view)
                        }
                    }
                    return v
                }
                
            case .TwoWeeks:
                if let isLast = chartPoint.last, isLast == false { //if let noOfReadingsCount = chartPoint.numberOfReadings, noOfReadingsCount != 1 {
                    
                        let v = ChartPointSmallSingleView(chartPoint: chartPoint, center: screenLoc, diameter: 12, borderWidth: 3, color: color)
                        v.viewTapped = {view in
                            for p in popups {p.removeFromSuperview()}
                            
                            func showLabel(view: ChartPointSmallSingleView){
                                selectedViewSmallSingle?.selected = false
                                
                                let w: CGFloat = 150
                                let h: CGFloat = 80
                                
                                let x: CGFloat = {
                                    let attempt = screenLoc.x - (w/2)
                                    let leftBound: CGFloat = chart.bounds.origin.x
                                    let rightBound = chart.bounds.size.width - 5
                                    if attempt < leftBound {
                                        return view.frame.origin.x
                                    } else if attempt + w > rightBound {
                                        return rightBound - w
                                    }
                                    return attempt
                                }()
                                
                                let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
                                
                                let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
                                chart.addSubview(bubbleView)
                                
                                bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
                                let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
                                infoView.textColor = UIColor.white
                                infoView.numberOfLines = 0
                                infoView.backgroundColor = color
                                infoView.text = self.getPopUpString(chartPoint: chartPoint, unit: "mmHg")
                                infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
                                infoView.textAlignment = NSTextAlignment.center
                                
                                bubbleView.addSubview(infoView)
                                popups.append(bubbleView)
                                
                                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                                    
                                    view.selected = true
                                    selectedViewSmallSingle = view
                                    
                                    bubbleView.transform = CGAffineTransform.identity
                                }, completion: {finished in})
                            }
                            
                            if v == selectedViewSmallSingle {
                                if v.selected == true {
                                    selectedViewSmallSingle?.selected = false
                                }else{
                                    showLabel(view: view)
                                }
                            }else{
                                showLabel(view: view)
                            }
                        }
                        return v
                }else{
                    let v = ChartPointSingleReadingView(chartPoint: chartPoint, center: screenLoc, diameter: 22, borderWidth: 3, color: color)
                    v.viewTapped = {view in
                        for p in popups {p.removeFromSuperview()}
                        
                        func showLabel(view: ChartPointSingleReadingView){
                            selectedView?.selected = false
                            
                            let w: CGFloat = 150
                            let h: CGFloat = 80
                            
                            let x: CGFloat = {
                                let attempt = screenLoc.x - (w/2)
                                let leftBound: CGFloat = chart.bounds.origin.x
                                let rightBound = chart.bounds.size.width - 5
                                if attempt < leftBound {
                                    return view.frame.origin.x
                                } else if attempt + w > rightBound {
                                    return rightBound - w
                                }
                                return attempt
                            }()
                            
                            let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
                            
                            let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
                            chart.addSubview(bubbleView)
                            
                            bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
                            let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
                            infoView.textColor = UIColor.white
                            infoView.backgroundColor = color
                            infoView.numberOfLines = 0
                            infoView.text = self.getPopUpString(chartPoint: chartPoint, unit: "mmHg")
                            infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
                            infoView.textAlignment = NSTextAlignment.center
                            
                            bubbleView.addSubview(infoView)
                            popups.append(bubbleView)
                            
                            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                                
                                view.selected = true
                                selectedView = view
                                
                                bubbleView.transform = CGAffineTransform.identity
                            }, completion: {finished in})
                        }
                        
                        if v == selectedView {
                            if v.selected == true {
                                selectedView?.selected = false
                            }else{
                                showLabel(view: view)
                            }
                        }else{
                            showLabel(view: view)
                        }
                    }
                    return v
                }
                
            case .Month:
                if let isLast = chartPoint.last, isLast == false {
                    let v = ChartPointMonthlyView(chartPoint: chartPoint, center: screenLoc, diameter: 8, borderWidth: 3, color: color)
                    v.viewTapped = {view in
                        for p in popups {p.removeFromSuperview()}
                        
                        func showLabel(view: ChartPointMonthlyView){
                            selectedViewMonthly?.selected = false
                            
                            let w: CGFloat = 150
                            let h: CGFloat = 80
                            
                            let x: CGFloat = {
                                let attempt = screenLoc.x - (w/2)
                                let leftBound: CGFloat = chart.bounds.origin.x
                                let rightBound = chart.bounds.size.width - 5
                                if attempt < leftBound {
                                    return view.frame.origin.x
                                } else if attempt + w > rightBound {
                                    return rightBound - w
                                }
                                return attempt
                            }()
                            
                            let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
                            
                            let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
                            chart.addSubview(bubbleView)
                            
                            bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
                            let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
                            infoView.textColor = UIColor.white
                            infoView.numberOfLines = 0
                            infoView.backgroundColor = color
                            infoView.text = self.getPopUpString(chartPoint: chartPoint, unit: "mmHg")
                            infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
                            infoView.textAlignment = NSTextAlignment.center
                            
                            bubbleView.addSubview(infoView)
                            popups.append(bubbleView)
                            
                            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                                
                                view.selected = true
                                selectedViewMonthly = view
                                
                                bubbleView.transform = CGAffineTransform.identity
                            }, completion: {finished in})
                        }
                        
                        if v == selectedViewMonthly {
                            if v.selected == true {
                                selectedViewMonthly?.selected = false
                            }else{
                                showLabel(view: view)
                            }
                        }else{
                            showLabel(view: view)
                        }
                    }
                    return v
                    
                }else{
                    let v = ChartPointSingleReadingView(chartPoint: chartPoint, center: screenLoc, diameter: 22, borderWidth: 3, color: color)
                    v.viewTapped = {view in
                        for p in popups {p.removeFromSuperview()}
                        
                        func showLabel(view: ChartPointSingleReadingView){
                            selectedView?.selected = false
                            
                            let w: CGFloat = 150
                            let h: CGFloat = 80
                            
                            let x: CGFloat = {
                                let attempt = screenLoc.x - (w/2)
                                let leftBound: CGFloat = chart.bounds.origin.x
                                let rightBound = chart.bounds.size.width - 5
                                if attempt < leftBound {
                                    return view.frame.origin.x
                                } else if attempt + w > rightBound {
                                    return rightBound - w
                                }
                                return attempt
                            }()
                            
                            let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
                            
                            let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
                            chart.addSubview(bubbleView)
                            
                            bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
                            let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
                            infoView.textColor = UIColor.white
                            infoView.backgroundColor = color
                            infoView.numberOfLines = 0
                            infoView.text = self.getPopUpString(chartPoint: chartPoint, unit: "mmHg")
                            infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
                            infoView.textAlignment = NSTextAlignment.center
                            
                            bubbleView.addSubview(infoView)
                            popups.append(bubbleView)
                            
                            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                                
                                view.selected = true
                                selectedView = view
                                
                                bubbleView.transform = CGAffineTransform.identity
                            }, completion: {finished in})
                        }
                        
                        if v == selectedView {
                            if v.selected == true {
                                selectedView?.selected = false
                            }else{
                                showLabel(view: view)
                            }
                        }else{
                            showLabel(view: view)
                        }
                    }
                    return v
                }
                
            case .ThreeMonths:
                if let isLast = chartPoint.last, isLast == false {
                    let v = ChartPointMonthlyView(chartPoint: chartPoint, center: screenLoc, diameter: 8, borderWidth: 3, color: color)
                    v.viewTapped = {view in
                        for p in popups {p.removeFromSuperview()}
                        
                        func showLabel(view: ChartPointMonthlyView){
                            selectedViewMonthly?.selected = false
                            
                            let w: CGFloat = 150
                            let h: CGFloat = 80
                            
                            let x: CGFloat = {
                                let attempt = screenLoc.x - (w/2)
                                let leftBound: CGFloat = chart.bounds.origin.x
                                let rightBound = chart.bounds.size.width - 5
                                if attempt < leftBound {
                                    return view.frame.origin.x
                                } else if attempt + w > rightBound {
                                    return rightBound - w
                                }
                                return attempt
                            }()
                            
                            let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
                            
                            let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
                            chart.addSubview(bubbleView)
                            
                            bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
                            let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
                            infoView.textColor = UIColor.white
                            infoView.numberOfLines = 0
                            infoView.backgroundColor = color
                            infoView.text = self.getPopUpString(chartPoint: chartPoint, unit: "mmHg")
                            infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
                            infoView.textAlignment = NSTextAlignment.center
                            
                            bubbleView.addSubview(infoView)
                            popups.append(bubbleView)
                            
                            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                                
                                view.selected = true
                                selectedViewMonthly = view
                                
                                bubbleView.transform = CGAffineTransform.identity
                            }, completion: {finished in})
                        }
                        
                        if v == selectedViewMonthly {
                            if v.selected == true {
                                selectedViewMonthly?.selected = false
                            }else{
                                showLabel(view: view)
                            }
                        }else{
                            showLabel(view: view)
                        }
                    }
                    return v
                    
                }else{
                    let v = ChartPointSingleReadingView(chartPoint: chartPoint, center: screenLoc, diameter: 22, borderWidth: 3, color: color)
                    v.viewTapped = {view in
                        for p in popups {p.removeFromSuperview()}
                        
                        func showLabel(view: ChartPointSingleReadingView){
                            selectedView?.selected = false
                            
                            let w: CGFloat = 150
                            let h: CGFloat = 80
                            
                            let x: CGFloat = {
                                let attempt = screenLoc.x - (w/2)
                                let leftBound: CGFloat = chart.bounds.origin.x
                                let rightBound = chart.bounds.size.width - 5
                                if attempt < leftBound {
                                    return view.frame.origin.x
                                } else if attempt + w > rightBound {
                                    return rightBound - w
                                }
                                return attempt
                            }()
                            
                            let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
                            
                            let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
                            chart.addSubview(bubbleView)
                            
                            bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
                            let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
                            infoView.textColor = UIColor.white
                            infoView.backgroundColor = color
                            infoView.numberOfLines = 0
                            infoView.text = self.getPopUpString(chartPoint: chartPoint, unit: "mmHg")
                            infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
                            infoView.textAlignment = NSTextAlignment.center
                            
                            bubbleView.addSubview(infoView)
                            popups.append(bubbleView)
                            
                            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                                
                                view.selected = true
                                selectedView = view
                                
                                bubbleView.transform = CGAffineTransform.identity
                            }, completion: {finished in})
                        }
                        
                        if v == selectedView {
                            if v.selected == true {
                                selectedView?.selected = false
                            }else{
                                showLabel(view: view)
                            }
                        }else{
                            showLabel(view: view)
                        }
                    }
                    return v
                }
            }
            
        }
        
        let itemsDelay: Float = 0.00
        let chartPointsCircleLayer1 = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, pointColor: UIColor.dmsPineGreen, chartPoints: chartPointsSysCom, viewGenerator: circleViewGenerator, displayDelay: 0.0, delayBetweenItems: itemsDelay)
        
        let chartPointsCircleLayer2 = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, pointColor: UIColor.dmsMango, chartPoints: chartPointsDiaCom, viewGenerator: circleViewGenerator, displayDelay: 0.0, delayBetweenItems: itemsDelay)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                coordsSpace.xAxis,
                coordsSpace.yAxis,
                guidelinesLayer,
                //                chartPointsLayer0,
                //                chartPointsLayer1,
                chartPointsLineLayer,
                chartPointsCircleLayer1,
                chartPointsCircleLayer2,
            ]
        )
        //        print("Width of Y axis: \(yAxis.rect.width + chartSettings.leading)")
        self.scrollView.addSubview(chart.view)
        self.scrollView.clipsToBounds = false
        self.contentView.clipsToBounds = false
        self.chart = chart
    }

}
