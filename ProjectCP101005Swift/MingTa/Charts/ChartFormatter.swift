//
//  ScoreAxisValueFormatter.swift
//  ProjectCP101005Swift
//
//  Created by Ming-Ta Yang on 2018/8/7.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation
import Charts

class ScoreAxisValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let valueString = String(value)
        
        switch (valueString) {
        case "6.0" :
            return "100分"
        case "5.0" :
            return "90~99分"
        case "4.0" :
            return "80~89分"
        case "3.0" :
            return "70~79分"
        case "2.0" :
            return "60~69分"
        case "1.0" :
            return "0~59分"
        default:
            return ""
        }
    }
    
}

class PeopleCountValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        let count = Int(value)
        return String(count) + "人";
    
    }

}




