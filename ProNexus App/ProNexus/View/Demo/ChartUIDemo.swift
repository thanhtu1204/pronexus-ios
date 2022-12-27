//
//  ChartUIDemo.swift
//  ProNexus
//
//  Created by thanh cto on 31/10/2021.
//

import SwiftUI

struct ChartUIDemo: View {
    
    var test: Double = 200000000.0
    
    var body: some View {
        VStack {
//            BarChartView(data: ChartData(values: [("2018 Q4",63150), 
//                                                  ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550), ("2019 Q4",92550), ("2019 Q4",92550), ("2019 Q4",92550) , ("2019 Q4",92550), ("2019 Q4",92550), ("2019 Q4",92550), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly", dropShadow: false) // legend is optional
//            
//            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", legend: "Legendary", dropShadow: false) // legend is optional
//            
//            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", form: ChartForm.small, dropShadow: true)

            Text("\(test)".convertDoubleToCurrency(symbol: ""))
                .frame(minWidth: 70)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(Color(hex: "#FFFFFF"))
                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
        }
    }
}

struct ChartUIDemo_Previews: PreviewProvider {
    static var previews: some View {
        ChartUIDemo()
    }
}
