//
//  BarChartCell.swift
//  ProNexus
//
//  Created by thanh cto on 05/12/2021.
//

import Foundation
import SwiftUI

struct BarChartData2 {
     var label: String
     var value: Double
     var display: Double
}

let chartDataSet = [
     BarChartData2(label: "January 2021", value: 340.32, display: 340.32),
     BarChartData2(label: "February 2021", value: 250.0, display: 340.32),
     BarChartData2(label: "March 2021", value: 430.22, display: 340.32),
     BarChartData2(label: "April 2021", value: 350.0, display: 340.32),
     BarChartData2(label: "May 2021", value: 450.0, display: 340.32),
     BarChartData2(label: "June 2021", value: 380.0, display: 340.32),
     BarChartData2(label: "July 2021", value: 365.98, display: 340.32)
]

struct BarChartCellView: View {
    
    var value: Double
    var barColor: Color
    var barlabel: String
    var displayValue: Double
    
    
    var body: some View {
        VStack {
            Text(String(displayValue).convertDoubleToCurrencyK()).regular(size: 10)
            RoundedRectangle(cornerRadius: 2.5)
                .fill(barColor)
                .scaleEffect(CGSize(width: 1, height: value), anchor: .bottom)
                .frame(width: 5)
            Text(barlabel).regular(size: 14)
        }
                    
    }
}

struct BarChartCellView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartCellView(value: 1, barColor: .blue, barlabel: "TEst", displayValue: 111111000)
            .previewLayout(.sizeThatFits)
    }
}
