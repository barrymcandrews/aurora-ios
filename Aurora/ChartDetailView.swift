//
//  ChartDetailView.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/1/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore
import Charts

class ChartDetailView: HorizontalBarChartView, DetailView, IAxisValueFormatter {
    var subtitle: String = "Color Components"
    let colors = ["Red", "Green", "Blue"]
    var wholeNumberFormatter: IValueFormatter?
    
    func setupContent() {
        let format = NumberFormatter()
        format.generatesDecimalNumbers = false
        wholeNumberFormatter = DefaultValueFormatter(formatter: format)
        
        self.backgroundColor = UIColor.clear
        self.noDataText = "Unable to display data."
        self.noDataTextColor = UIColor.flatGray()
        self.doubleTapToZoomEnabled = false
        
        self.xAxis.valueFormatter = self
        self.xAxis.granularity = 1
    
        self.rightAxis.axisMinimum = 0
        self.rightAxis.axisMaximum = 100

        self.leftAxis.axisMinimum =  0
        self.leftAxis.axisMaximum = 100
        
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.drawAxisLineEnabled = false
        self.xAxis.labelCount = 3
        self.xAxis.labelPosition = .bottom
        self.xAxis.labelTextColor = UIColor.white
        self.xAxis.labelFont = UIFont(name: "Futura-MediumItalic", size: 18)!
        
        self.legend.enabled = false
        self.leftAxis.enabled = false
        self.rightAxis.enabled = false
        self.extraTopOffset = 0
        self.extraBottomOffset = 30
        self.extraRightOffset = 40
        self.chartDescription?.text = ""
    }
    
    func prepareContent(context: Request) {
        if let req = context as? ColorRequest {
            var dataEntries: [BarChartDataEntry] = []
            let components = req.color.components
            dataEntries.append(BarChartDataEntry(x: 0, y: Double(Int(components.red * 100))))
            dataEntries.append(BarChartDataEntry(x: 1, y: Double(Int(components.green * 100))))
            dataEntries.append(BarChartDataEntry(x: 2, y: Double(Int(components.blue * 100))))
            
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Power Level")
            chartDataSet.setColors(UIColor.flatRed(), UIColor.flatGreen(), UIColor.flatBlue())
            
            self.data = BarChartData(dataSet: chartDataSet)
            self.barData?.barWidth = 0.6
            self.barData?.setValueFormatter(wholeNumberFormatter)
            self.barData?.setValueTextColor(UIColor.flatGray())
            self.barData?.setValueFont(UIFont(name: "Futura-MediumItalic", size: 14)!)
        }
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return colors[Int(value)]
    }
}

