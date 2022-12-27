//
//  TransactionBarChartView.swift
//  ProNexus
//
//  Created by thanh cto on 17/12/2021.
//

import Charts
import SwiftUI

struct WineTransaction {
    var year: Int
    var month: Double
    var quantity: Double
    
    static func dataEntriesForYear(_ year: Int, transactions:[WineTransaction]) -> [BarChartDataEntry] {
    let yearTransactions = transactions.filter{$0.year == year}
           return yearTransactions.map{BarChartDataEntry(x: $0.month, y: $0.quantity)}
    }
    static var months = ["Jan","Feb","Mar","Apr","May","Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    static var allTransactions:[WineTransaction] {
        [
            WineTransaction(year: 2019, month: 0, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 1, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 2, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 3, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 4, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 5, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 6, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 7, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 8, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 9, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 10, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 11, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 12, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 13, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2019, month: 14, quantity: Double(Int.random(in: 0..<10000))),
            WineTransaction(year: 2020, month: 0, quantity: 43),
            WineTransaction(year: 2020, month: 1, quantity: 0),
            WineTransaction(year: 2020, month: 2, quantity: 22),
            WineTransaction(year: 2020, month: 3, quantity: 15),
            WineTransaction(year: 2020, month: 4, quantity: 88),
            WineTransaction(year: 2020, month: 5, quantity: 7),
            WineTransaction(year: 2020, month: 6, quantity: 0),
            WineTransaction(year: 2020, month: 7, quantity: 0),
            WineTransaction(year: 2020, month: 8, quantity: 0),
            WineTransaction(year: 2020, month: 9, quantity: 0),
            WineTransaction(year: 2020, month: 10, quantity: 0),
            WineTransaction(year: 2020, month: 11, quantity: 0)
        ]
    }
}

struct TransactionBarChartView: UIViewRepresentable {

    var entries: [BarChartDataEntry] = []
    let barChart = BarChartView()
    
    let groupSpace: Double = 1.0
           let barSpace: Double = 0.1
           let barWidth: Double = 0.3
    
    @Binding var selectedYear: Int
    @Binding var selectedItem: String
    func makeUIView(context: Context) -> BarChartView {
        barChart.delegate = context.coordinator
        return barChart
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.label = "Transactions"
        
        let dataSet2 = BarChartDataSet(entries: WineTransaction.dataEntriesForYear(2020, transactions: WineTransaction.allTransactions))
        dataSet2.label = "Set"
        
        uiView.noDataText = "No Data"
        var barChartData = BarChartData(dataSets: [dataSet, dataSet2]);
        barChartData.barWidth = barWidth
        uiView.data = barChartData
        uiView.rightAxis.enabled = false
        if uiView.scaleX == 1.0 {
            uiView.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
        }
        uiView.setScaleEnabled(false)
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        uiView.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace) // nếu muốn nhiều cột thì mở thuộc tính này.
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent:TransactionBarChartView
        init(parent: TransactionBarChartView) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            let month = WineTransaction.months[Int(entry.x)]
            let quantity = Int(entry.y)
            parent.selectedItem = "\(quantity) sold in \(month)"
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func formatDataSet(dataSet: BarChartDataSet) {
        dataSet.colors = [colorWithHexString(hexString: "#FFB331"), colorWithHexString(hexString: "#0974DF")]
        dataSet.valueColors = [colorWithHexString(hexString: "#939393")]
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = colorWithHexString(hexString: "#939393")
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
//        xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        xAxis.labelCount = 25
        xAxis.granularity = 1.0
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = colorWithHexString(hexString: "#939393")
    }
    
    func formatLegend(legend: Legend) {
        legend.textColor = colorWithHexString(hexString: "#939393")
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.drawInside = true
        legend.yOffset = 30.0
        
    }
    
    func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {

           // Convert hex string to an integer
        // Convert hex string to an integer
           let hexint = Int(self.intFromHexString(hexStr: hexString))
           let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
           let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
           let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
           
           // Create color object, specifying alpha as well
           let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
           return color
       }
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
   
}

struct TransactionBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionBarChartView(entries: WineTransaction.dataEntriesForYear(2019, transactions: WineTransaction.allTransactions),
                                selectedYear: .constant(2019),
                                selectedItem: .constant(""))
    }
}
