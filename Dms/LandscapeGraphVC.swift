//
//  LandscapeGraphVC.swift
//  FTN
//
//  Created by Marko Stajic on 12/28/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class LandscapeGraphVC: UIViewController {
    
//    var isPresented : Bool = true
//    
//    @IBOutlet weak var separatorView: UIView!
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var systolicDotImage: UIView!
//    @IBOutlet weak var diastolicDotImage: UIView!
//    @IBOutlet weak var systolicLabel: CellTitle!
//    @IBOutlet weak var diastolicLabel: CellTitle!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var collapseGraphButton: UIButton!
//
//    fileprivate var chart: Chart? // arc
////    fileprivate var chartY: Chart?
//    let calendar = Calendar.current
//    var bloodPressureResultsArray : BloodPressureAverageResults! {
//        didSet {
//            updateChartWithData(array: bloodPressureResultsArray)
//        }
//    }
//    var daysToShow : GraphPeriod = GraphPeriod.Week {
//        didSet {
//            
//            if bloodPressureResultsArray != nil {
//                updateChartWithData(array: self.bloodPressureResultsArray)
//            }
//        }
//    }
//    var chartPointsSys = [ChartPoint]()
//    var chartPointsDia = [ChartPoint]()
//    var xValues = [ChartAxisValue]()
//    var iPhoneLandscapeChartSettings: ChartSettings {
//        let chartSettings = ChartSettings()
//        chartSettings.leading = 10
//        chartSettings.top = 5
//        chartSettings.trailing = 10
//        chartSettings.bottom = 0
//        chartSettings.labelsToAxisSpacingX = 5
//        chartSettings.labelsToAxisSpacingY = 5
//        chartSettings.axisTitleLabelsToLabelsSpacing = 4
//        chartSettings.axisStrokeWidth = 0.2
//        chartSettings.spacingBetweenAxesX = 8
//        chartSettings.spacingBetweenAxesY = 8
//        return chartSettings
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateViews()
//        
//        if bloodPressureResultsArray != nil {
//            updateChartWithData(array: self.bloodPressureResultsArray)
//        }
//        // Do any additional setup after loading the view.
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if let periodCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PeriodCollectionCell {
//            periodCell.selectedCell = true
//            self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.left)
//        }
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    func updateViews(){
//        systolicLabel.textColor = UIColor.dmsPineGreen
//        diastolicLabel.textColor = UIColor.dmsPineGreen
//        systolicLabel.updateFont(size: 14.0)
//        diastolicLabel.updateFont(size: 14.0)
//        
//        systolicDotImage.layer.borderColor = UIColor.dmsPineGreen.cgColor
//        systolicDotImage.layer.borderWidth = 2.0
//        diastolicDotImage.layer.borderColor = UIColor.dmsMango.cgColor
//        diastolicDotImage.layer.borderWidth = 2.0
//        systolicDotImage.layer.cornerRadius = 5.0
//        diastolicDotImage.layer.cornerRadius = 5.0
//        
//        systolicDotImage.backgroundColor = UIColor.clear
//        diastolicDotImage.backgroundColor = UIColor.clear
//        separatorView.backgroundColor = UIColor.dmsPaleGrey
//        
//        scrollView.bounces = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.clipsToBounds = false
//        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(UINib(nibName: String(describing: PeriodCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PeriodCollectionCell.self))
//    }
//    
//    @IBAction func dismissGraph(_ sender: UIButton) {
//        self.isPresented = false
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func getGraphString(date: Date) -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
//        return dateFormatter.string(from: date)
//    }
//    func cutDateToMidnight(dateToCut: Date) -> Date?{
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd"
//        df.timeZone = TimeZone(abbreviation: "GMT+0:00")
//        return df.date(from: df.string(from: dateToCut))
//    }
//    func fillXValuesArray(days: Int){
//        
//        let readFormatter = DateFormatter()
//        readFormatter.dateFormat = "MM/dd/yyyy"
//        
//        let displayFormatter = DateFormatter()
//        displayFormatter.dateFormat = "MMM/dd"
//        
//        xValues.removeAll()
//        var endDate = calendar.date(byAdding: Calendar.Component.day, value: +1, to: Date()) ?? Date() //Date()
//        var pastDate = Date()
//        xValues.append(createDateAxisValue(self.getGraphString(date: endDate), readFormatter: readFormatter, displayFormatter: displayFormatter))
//        
//        for _ in 0..<days {
//            pastDate = calendar.date(byAdding: Calendar.Component.day, value: -1, to: endDate) ?? Date()
//            xValues.append(createDateAxisValue(self.getGraphString(date: pastDate), readFormatter: readFormatter, displayFormatter: displayFormatter))
//            endDate = pastDate
//        }
//        xValues = xValues.reversed()
//        
//    }
//    
//    func updateChartWithData(array: BloodPressureAverageResults) {
////        self.chartY?.view.removeFromSuperview()
//        self.chart?.view.removeFromSuperview()
//        self.chart?.view.clipsToBounds = false
//        chartPointsDia.removeAll()
//        chartPointsSys.removeAll()
//        xValues.removeAll()
//        
//        let labelSettings = ChartLabelSettings(font: UIFont(name: Font.GothamBold, size: 12.0)!)
//        
//        var readFormatter = DateFormatter()
//        readFormatter.dateFormat = "MM/dd/yyyy"
//        
//        var displayFormatter = DateFormatter()
//        displayFormatter.dateFormat = "dd.MM.yyyy"
//        
//        let date = {(str: String) -> Date in
//            return readFormatter.date(from: str)!
//        }
//        
//        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
//            var components = DateComponents()
//            components.day = day
//            components.month = month
//            components.year = year
//            return self.calendar.date(from: components)!
//        }
//        
//        func filler(_ date: Date) -> ChartAxisValueDate {
//            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
//            filler.hidden = true
//            return filler
//        }
//        
//        let systolicArray = array.systolic
//        let diastolicArray = array.diastolic
//        
//        for (index,i) in systolicArray.enumerated() {
//            
//            chartPointsSys.append(createChartPointWithReadingsCount(dateStr: self.getGraphString(date: i.date), y: i.value, numberOfReadings: i.numberOfReadings, readFormatter: readFormatter, displayFormatter: displayFormatter))
//        }
//        
//        for (index,i) in diastolicArray.enumerated() {
//            chartPointsDia.append(createChartPointWithReadingsCount(dateStr: self.getGraphString(date: i.date), y: i.value, numberOfReadings: i.numberOfReadings, readFormatter: readFormatter, displayFormatter: displayFormatter))
//        }
//        
//        for (index,i) in chartPointsSys.enumerated() {
//            print("Systolic points \(index): \(i.y) Count: \(i.numberOfReadings)")
//        }
//        
//        for (index,i) in chartPointsDia.enumerated() {
//            print("Diastolic points \(index): \(i.y) Count: \(i.numberOfReadings)")
//        }
//        
//        fillXValuesArray(days: daysToShow.days)
//        
//        let yValues = stride(from: 40, through: 160, by: 20).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
//        
//        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
//        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings.defaultVertical()))
//        let scrollViewFrame = scrollView.frame
//        
//        var chartFrame = CGRect()
//        
//        switch daysToShow {
//        case .Week:
//            chartFrame = CGRect(x: 0, y: 5, width: CGFloat(daysToShow.days * 100), height: scrollViewFrame.size.height+15)
//        case .TwoWeeks:
//            chartFrame = CGRect(x: 0, y: 5, width: CGFloat(daysToShow.days * 70), height: scrollViewFrame.size.height+15)
//        case .Month:
//            chartFrame = CGRect(x: 0, y: 5, width: CGFloat(daysToShow.days * 60), height: scrollViewFrame.size.height+15)
//        case .ThreeMonths:
//            chartFrame = CGRect(x: 0, y: 5, width: CGFloat(daysToShow.days * 50), height: scrollViewFrame.size.height+15)
//        }
//        
//        scrollView.contentSize = CGSize(width: chartFrame.size.width, height: chartFrame.size.height - 15)
//        let chartSettings = self.iPhoneLandscapeChartSettings
//        chartSettings.trailing = 80
//        
//        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
//        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
//        
//        let c0 = UIColor.dmsMetallicBlue.withAlphaComponent(0.7)
//        let c1 = UIColor.dmsMango.withAlphaComponent(0.7)
//        
//        let chartPointsLayer0 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPointsSys, areaColor: c0, animDuration: 3, animDelay: 0, addContainerPoints: true)
//        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPointsDia, areaColor: c1, animDuration: 3, animDelay: 0, addContainerPoints: true)
//        
//        let lineModel0 = ChartLineModel(chartPoints: chartPointsSys, lineColor: UIColor.dmsMetallicBlue, lineWidth: 2.0, animDuration: 1, animDelay: 0)
//        let lineModel1 = ChartLineModel(chartPoints: chartPointsDia, lineColor: UIColor.dmsMango, lineWidth: 2.0, animDuration: 1, animDelay: 0)
//        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel0, lineModel1])
//        
//        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.dmsMetallicBlue, linesWidth: 0.5)
//        let guidelinesLayer = ChartGuideLinesLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, axis: ChartGuideLinesLayerAxis.y, settings: settings, onlyVisibleX: false, onlyVisibleY: true)
//        
//        var popups: [UIView] = []
//        
//        var selectedViewAverage: ChartPointAverageView?
//        var selectedView: ChartPointSingleReadingView? //ChartPointTextCircleView?
//        
//        let circleViewGenerator = {(color: UIColor, chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
//            
//            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
//            
//            print("Chart point in generator: \(chartPoint.x) \(chartPoint.y) \(chartPoint.numberOfReadings)")
//            
//            if let noOfReadingsCount = chartPoint.numberOfReadings, noOfReadingsCount != 1 {
//                let v = ChartPointAverageView(chartPoint: chartPoint, center: screenLoc, diameter: 30, borderWidth: 3, color: color)
//                v.viewTapped = {view in
//                    for p in popups {p.removeFromSuperview()}
//                    
//                    func showLabel(view: ChartPointAverageView){
//                        selectedViewAverage?.selected = false
//                        
//                        let w: CGFloat = 150
//                        let h: CGFloat = 80
//                        
//                        let x: CGFloat = {
//                            let attempt = screenLoc.x - (w/2)
//                            let leftBound: CGFloat = chart.bounds.origin.x
//                            let rightBound = chart.bounds.size.width - 5
//                            if attempt < leftBound {
//                                return view.frame.origin.x
//                            } else if attempt + w > rightBound {
//                                return rightBound - w
//                            }
//                            return attempt
//                        }()
//                        
//                        let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
//                        
//                        let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
//                        chart.addSubview(bubbleView)
//                        
//                        bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
//                        let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
//                        infoView.textColor = UIColor.white
//                        infoView.numberOfLines = 0
//                        infoView.backgroundColor = color
//                        if let noOfReadings = chartPoint.numberOfReadings {
//                            infoView.text = "Average value: \(chartPoint.y)\nReadings this day: \(noOfReadings)"
//                        }else{
//                            infoView.text = "Value: \(chartPoint.y)"
//                        }
//                        infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
//                        infoView.textAlignment = NSTextAlignment.center
//                        
//                        bubbleView.addSubview(infoView)
//                        popups.append(bubbleView)
//                        
//                        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
//                            
//                            view.selected = true
//                            selectedViewAverage = view
//                            
//                            bubbleView.transform = CGAffineTransform.identity
//                        }, completion: {finished in})
//                    }
//                    
//                    if v == selectedViewAverage {
//                        if v.selected == true {
//                            selectedViewAverage?.selected = false
//                        }else{
//                            showLabel(view: view)
//                        }
//                    }else{
//                        showLabel(view: view)
//                    }
//                }
//                return v
//            }else{
//                let v = ChartPointSingleReadingView(chartPoint: chartPoint, center: screenLoc, diameter: 22, borderWidth: 3, color: color)
//                v.viewTapped = {view in
//                    for p in popups {p.removeFromSuperview()}
//                    
//                    func showLabel(view: ChartPointSingleReadingView){
//                        selectedView?.selected = false
//                        
//                        let w: CGFloat = 150
//                        let h: CGFloat = 80
//                        
//                        let x: CGFloat = {
//                            let attempt = screenLoc.x - (w/2)
//                            let leftBound: CGFloat = chart.bounds.origin.x
//                            let rightBound = chart.bounds.size.width - 5
//                            if attempt < leftBound {
//                                return view.frame.origin.x
//                            } else if attempt + w > rightBound {
//                                return rightBound - w
//                            }
//                            return attempt
//                        }()
//                        
//                        let frame = CGRect(x: x, y: screenLoc.y - (h + (12)), width: w, height: h)
//                        
//                        let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: color, arrowX: screenLoc.x - x)
//                        chart.addSubview(bubbleView)
//                        
//                        bubbleView.transform = CGAffineTransform(scaleX: 0, y: 0).concatenating(CGAffineTransform(translationX: 0, y: 100))
//                        let infoView = UILabel(frame: CGRect(x: 0, y: 10, width: w, height: h - 30))
//                        infoView.textColor = UIColor.white
//                        infoView.backgroundColor = color
//                        infoView.numberOfLines = 0
//                        if let noOfReadings = chartPoint.numberOfReadings {
//                            infoView.text = "Average value: \(chartPoint.y)\nBased on: \(noOfReadings) reading"
//                        }else{
//                            infoView.text = "Value: \(chartPoint.y)"
//                        }
//                        infoView.font = UIFont(name: Font.GothamMedium, size: 12.0)!
//                        infoView.textAlignment = NSTextAlignment.center
//                        
//                        bubbleView.addSubview(infoView)
//                        popups.append(bubbleView)
//                        
//                        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
//                            
//                            view.selected = true
//                            selectedView = view
//                            
//                            bubbleView.transform = CGAffineTransform.identity
//                        }, completion: {finished in})
//                    }
//                    
//                    if v == selectedView {
//                        if v.selected == true {
//                            selectedView?.selected = false
//                        }else{
//                            showLabel(view: view)
//                        }
//                    }else{
//                        showLabel(view: view)
//                    }
//                }
//                return v
//            }
//        }
//        
//        let itemsDelay: Float = 0.00
//        let chartPointsCircleLayer1 = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, pointColor: UIColor.dmsPineGreen, chartPoints: chartPointsSys, viewGenerator: circleViewGenerator, displayDelay: 0.0, delayBetweenItems: itemsDelay)
//        
//        let chartPointsCircleLayer2 = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, pointColor: UIColor.dmsOrange, chartPoints: chartPointsDia, viewGenerator: circleViewGenerator, displayDelay: 0.0, delayBetweenItems: itemsDelay)
//        
//        let chart = Chart(
//            frame: chartFrame,
//            layers: [
//                coordsSpace.xAxis,
//                coordsSpace.yAxis,
//                guidelinesLayer,
//                chartPointsLayer0,
//                chartPointsLayer1,
//                chartPointsLineLayer,
//                chartPointsCircleLayer1,
//                chartPointsCircleLayer2,
//                ]
//        )
//        
//        //        let axisChart = Chart(frame: CGRect(x: 8, y: 58+52, width: yAxis.rect.width + chartSettings.leading, height: yAxis.rect.height + chartSettings.top + 7), layers: [yAxis, guidelinesLayer])
//        
//        print("Width of Y axis: \(yAxis.rect.width + chartSettings.leading)")
//        self.scrollView.addSubview(chart.view)
//        //        axisChart.view.backgroundColor = UIColor.clear
//        //        self.view.addSubview(axisChart.view)
//        self.view.clipsToBounds = false
//        self.chart = chart
//        //        self.chartY = axisChart
//    }

}

extension LandscapeGraphVC {
//    fileprivate func createChartPoint(_ x: Double, _ y: Double, _ labelSettings: ChartLabelSettings) -> ChartPoint {
//        return ChartPoint(x: ChartAxisValueDouble(x, labelSettings: labelSettings), y: ChartAxisValueDouble(y))
//    }
//    fileprivate func createChartPoint(_ x: Int, _ y: Double, _ labelSettings: ChartLabelSettings) -> ChartPoint {
//        return ChartPoint(x: ChartAxisValueDouble(x, labelSettings: labelSettings), y: ChartAxisValueDouble(y))
//    }
//    func createChartPointWithReadingsCount(dateStr: String, y: Double, numberOfReadings: Int, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartPoint {
//        return ChartPoint(x: self.createDateAxisValue(dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter), y: ChartAxisValueDouble(y), numberOfReadings: numberOfReadings)
//    }
//    func createChartPoint(dateStr: String, y: Double, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartPoint {
//        return ChartPoint(x: self.createDateAxisValue(dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter), y: ChartAxisValueDouble(y))
//    }
//    func createDateAxisValue(_ dateStr: String, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartAxisValue {
//        
//        let date = readFormatter.date(from: dateStr)!
//        let labelSettings = ChartLabelSettings(font: UIFont(name: Font.GothamMedium, size: 12.0)!, rotation: 30.0, rotationKeep: .top)
//        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
//    }
//    class ChartAxisValuePercent: ChartAxisValueDouble {
//        override var description: String {
//            return "\(self.formatter.string(from: NSNumber(value: self.scalar))!)%"
//        }
//    }
}

//extension LandscapeGraphVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if let periodCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PeriodCollectionCell.self), for: indexPath) as? PeriodCollectionCell {
//            periodCell.periodLabel.text = GraphPeriod(rawValue: indexPath.row)?.description
//            return periodCell
//        }
//        
//        let defaultCell = UICollectionViewCell() //(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
//        return defaultCell
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let periodCell = collectionView.cellForItem(at: indexPath) as? PeriodCollectionCell {
//            periodCell.selectedCell = true
//            self.daysToShow = GraphPeriod(rawValue: indexPath.row) ?? GraphPeriod.Week
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let periodCell = collectionView.cellForItem(at: indexPath) as? PeriodCollectionCell {
//            periodCell.selectedCell = false
//        }
//        
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellSize = CGSize(width: (UIScreen.main.bounds.width - 58.0)/4.0, height: 50.0)
//        return cellSize
//    }
//    
//}
