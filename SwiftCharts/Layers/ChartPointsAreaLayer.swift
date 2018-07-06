//
//  ChartPointsAreaLayer.swift
//  swiftCharts
//
//  Created by ischuetz on 15/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

open class ChartPointsAreaLayer<T: ChartPoint>: ChartPointsLayer<T> {
    
    fileprivate let areaColor: UIColor
    fileprivate let animDuration: Float
    fileprivate let animDelay: Float
    fileprivate let addContainerPoints: Bool
    fileprivate var height: CGFloat = 100
    
    public init(xAxis: ChartAxisLayer, yAxis: ChartAxisLayer, innerFrame: CGRect, chartPoints: [T], areaColor: UIColor, animDuration: Float, animDelay: Float, addContainerPoints: Bool) {
        self.areaColor = areaColor
        self.animDuration = animDuration
        self.animDelay = animDelay
        self.addContainerPoints = addContainerPoints
        
        super.init(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints)
    }
    
    public init(xAxis: ChartAxisLayer, yAxis: ChartAxisLayer, height: CGFloat, innerFrame: CGRect, chartPoints: [T], areaColor: UIColor, animDuration: Float, animDelay: Float, addContainerPoints: Bool) {
        self.areaColor = areaColor
        self.animDuration = animDuration
        self.animDelay = animDelay
        self.addContainerPoints = addContainerPoints
        self.height = height
        
        super.init(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints)
    }
    
    override func display(chart: Chart) {
        var points = self.chartPointScreenLocs
        
        let origin = self.innerFrame.origin
        let xLength = self.innerFrame.width
        
        let bottomY = origin.y + self.innerFrame.height

        if self.addContainerPoints {
            points.append(CGPoint(x: origin.x + xLength, y: bottomY))
            points.append(CGPoint(x: origin.x, y: bottomY))
        }
        
        let areaView = ChartAreasView(points: points, frame: chart.bounds, color: self.areaColor, animDuration: self.animDuration, animDelay: self.animDelay, height: self.height)
        chart.addSubview(areaView)
    }
}
