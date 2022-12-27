//
//  SavingsPlan-TableAndChartView.swift
//  ProNexus
//
//  Created by TUYEN on 12/6/21.
//

import SwiftUI
import Charts



struct SavingsPlan_TableAndChartView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State var model: SavingPlanResponseModel?
    @State var tabIndex = 0
    @State var set1: [BarChartDataEntry] = []
    @State var set2: [BarChartDataEntry] = []
    
    var body: some View {
        VStack(spacing: 25) {
            Header(title: "Kế hoạch tiết kiệm", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                Spacer()
            })
                .padding(.bottom, 15)
            
            ScrollView() {
            
                VStack {
                    VStack() {
                        Group () {
                            VStack(alignment: .leading) {
                                
                                Text("Để đạt mục tiêu tiết kiệm ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text("\(model?.payload?.income ?? 0)".convertDoubleToCurrency())
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                + Text(" trong ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text("\(model?.payload?.years ?? 0) Năm")
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                + Text(" với mức lãi hàng năm ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))

                                + Text(String(format: "%.1f", (model?.payload?.interest ?? 0) * 100))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                + Text("%, mỗi kỳ bạn cần phải đầu tư:")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                            }
                            
                        }
                        .padding(.bottom , 15)
                        
                        VStack(alignment: .center) {
                            Text("\(model?.payload?.investment ?? 0)".convertDoubleToCurrency()).appFont(style: .body, weight: .bold,size: 20, color: Color(hex: "#FFFFFF"))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 4)
                        }
                        .background(Color(hex: "#FFB331"))
                        .cornerRadius(100)
                        
                        LineDash()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .padding(.vertical,22)
                            .foregroundColor( Color(hex: "#A4A4A4"))
                        
                        VStack(spacing: 20) {
                            HStack() {
                                Text("Đầu tư tích luỹ").appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D"))
                                Spacer()
                                Text("\(model?.payload?.cumulativeInvestment ?? 0)".convertDoubleToCurrency()).appFont(style: .body, weight: .bold,size: 14, color: Color(hex: "#4C99F8"))
                            }
                            
                            HStack() {
                                Text("Lãi tích luỹ").appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D"))
                                Spacer()
                                Text("\(model?.payload?.accruedInterest ?? 0)".convertDoubleToCurrency()).appFont(style: .body,weight: .bold, size: 14, color: Color(hex: "#4C99F8"))
                            }
                        }
                        
                    }
                    .padding(.all, 20)
                    .frame(width: UIScreen.screenWidth - 76)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow()
                    
                    Spacer(minLength: 20)
                             
                    VStack (alignment: .center) {
                        SavingPlanTabBar(tabIndex: $tabIndex)
                            .frame(width: UIScreen.screenWidth - 74)
                        if tabIndex == 1 {
                            if let charts = model?.payload?.charts {
                                SavingPlanTableView(data: charts)
                            }
                            
                        }
                        if tabIndex == 0 {
                            BarChartToolsView(set1: $set1, set2: $set2)
        //                    TransactionBarChartView(entries: WineTransaction.dataEntriesForYear(2019, transactions: WineTransaction.allTransactions),
        //                                            selectedYear: .constant(2019),
        //                                            selectedItem: .constant(""))
                        }
                        Spacer()
                    }
                    .padding(.all, 0)
                    .frame(width: UIScreen.screenWidth - 74, height: 390)
                    .background(Color("button"))
                    .cornerRadius(15)
                    .myShadow()
                    
                }.padding(SwiftUI.Edge.Set.horizontal, 15)
                    .padding(.bottom, 10)
            
            }
                
            
            VStack{
                VStack{
                    HStack{
                        Spacer()
                        Button(action: {
                            // closing popup...
                        }, label: {
                            Image(systemName: "xmark").resizable().frame(width: 10, height: 10).foregroundColor(Color(hex: "#CCCCCC"))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                    }.padding(.top,15)
                    
                    VStack(alignment:.center){
                        Text("Lựa chọn phương án tối ưu với sự đồng hành của cố vấn tài chính tin cậy.")
                            .appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D"))
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(SwiftUI.TextAlignment.leading)
                    }
                    .padding(.horizontal,22)
                    
                    VStack(alignment: .center, content: {
                        
                        NavigationLink(destination: SearchAdvisorView().environmentObject(ProviderApiService())
                                        .environmentObject(ClassificationApiService())
                                        .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                        ) {
                            Text("Tìm cố vấn").regular(size: 14, color: .white)
                        }.buttonStyle(BlueButton(w: 130))
                        
//                        Button {
//                            //                    self.isShowConfirmBookingEmpty = true
//                        } label: {
//                            Text("Tìm cố vấn")
//                        }.buttonStyle(BlueButton(w: 130))
                        
                    }).padding(.top,15)
                    .padding(.bottom,27)
                    
                }.padding(.horizontal,20)
                
                
            }
            .frame(width:screenWidth()-74)
            .background(Color.white)
            .cornerRadius(15)
            .myShadow()
            .padding(.top,0)
            .padding(.all,2)
            
            
            Spacer()
        }.onAppear() {
            buildChart()
        }
    }
    
    func buildChart() {
        self.set1.removeAll();
        self.set2.removeAll();
        if let charts = model?.payload?.charts {
            charts.forEach { item in
                print("x=", Double(item.year ?? 0))
                print("y=", Double(item.firstBalance ?? 0) / 1000 )
                self.set1.append(BarChartDataEntry(x: Double(item.year ?? 0), y: Double((item.firstBalance ?? 0) / 1000000)))
                self.set2.append(BarChartDataEntry(x: Double(item.year ?? 0), y: Double((item.lastBalance ?? 0) / 1000000)))
            }
        }
    }
}

struct SavingPlanTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 0) {
            TabBarButtonRadius(text: "Biểu đồ", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButtonRadius(text: "Lịch trình (nghìn VNĐ)", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
        }
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct SavingPlanTableView: View {
    
    @State var data: [SavingChart]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                Text("Năm")
                    .frame(minWidth: 20)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Đầu tư tích luỹ")
                    .frame(minWidth: 90)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Lãi tích luỹ")
                    .frame(minWidth: 70)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Tổng tiền tiết kiệm")
                    .frame(minWidth: 80)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
            }
            .frame(height: 30)
            
            if let items = data {
                ScrollView(showsIndicators: false) {
                    ForEach(items) { item in
                        HStack(spacing: 4) {
                            Text("\(item.year ?? 0)")
                                .frame(minWidth: 20, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text(String(format: "%.2f", (item.firstBalance ?? 0)))
                                .frame(minWidth: 90, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text(String(format: "%.2f", (item.interest ?? 0)))
                                .frame(minWidth: 70, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text(String(format: "%.2f", (item.lastBalance ?? 0)))
                                .frame(minWidth: 80, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                        }
                        .frame(height: 30)
                    }
                }
            }
         
        }
        .padding()
    }
}

final class MyCustomeAxisValueFormatter: IndexAxisValueFormatter {
    func stringFormatValue(_ value: Double, axis: AxisBase?) -> String {
        let intVal = Int(value)
        return "\(intVal)"
    }
}

struct BarChartToolsView: UIViewRepresentable {

    @Binding var set1: [BarChartDataEntry]
    @Binding var set2: [BarChartDataEntry]
    let barChart = BarChartView()
    
    let groupSpace: Double = 0.2
    let barSpace: Double = 0.1
    let barWidth: Double = 0.5

    func makeUIView(context: Context) -> BarChartView {
        barChart.delegate = context.coordinator
        return barChart
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        if set1 != nil && set2 != nil {
            
            let dataSet = BarChartDataSet(entries: set1)
            dataSet.label = "Đầu tư tích luỹ"
            
            let dataSet2 = BarChartDataSet(entries: set2)
            dataSet2.label = "Lãi tích luỹ"
            
            uiView.noDataText = "No Data"
            let barChartData = BarChartData(dataSets: [dataSet, dataSet2]);
            barChartData.barWidth = barWidth
            
            
            let floatValue: [CGFloat] = [2,2]

            uiView.xAxis.axisLineColor = UIColor.clear
            uiView.getAxis(.right).axisLineColor = UIColor.clear
            uiView.getAxis(.left).axisLineColor = UIColor.clear
            uiView.xAxis.labelPosition = .bottom
            uiView.xAxis.drawGridLinesEnabled = true
            uiView.xAxis.gridLineDashLengths = floatValue
            uiView.xAxis.drawLabelsEnabled = true
//            uiView.rightAxis.labelCount = Int(2)
//            uiView.rightAxis.drawGridLinesEnabled = false
            uiView.leftAxis.drawGridLinesEnabled = true
            uiView.leftAxis.gridColor = UIColor.lightGray
            uiView.leftAxis.gridLineWidth = CGFloat(0.5)
            uiView.leftAxis.gridLineDashLengths = floatValue

            
            uiView.data = barChartData
            uiView.rightAxis.enabled = false
            
            if uiView.scaleX == 1.0 {
                uiView.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
            }
            uiView.setScaleEnabled(true)

            formatLeftAxis(leftAxis: uiView.leftAxis)
            formatXAxis(xAxis: uiView.xAxis)
//            formatYAxis(yAxis: uiView.yAxis)
//            formatLegend(legend: uiView.legend)
            formatDataSet(dataSet: dataSet, color: colorWithHexString(hexString: "#FFB331"))
            formatDataSet(dataSet: dataSet2, color: colorWithHexString(hexString: "#0974DF"))
            uiView.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace) // nếu muốn nhiều cột thì mở thuộc tính này.
            uiView.notifyDataSetChanged()
        }
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent:BarChartToolsView
        init(parent: BarChartToolsView) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    

    func formatDataSet(dataSet: BarChartDataSet, color: UIColor) {
        dataSet.colors = [color]
        dataSet.valueColors = [color]
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "M"
        formatter.locale = Locale(identifier: "vi_VN")
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = colorWithHexString(hexString: "#939393")
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "M"
        formatter.locale = Locale(identifier: "vi_VN")
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
//        formatter.currencySymbol = "K"
//        formatter.locale = Locale(identifier: "vi_VN")
        xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
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


struct SavingsPlan_TableAndChartView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsPlan_TableAndChartView()
//        SavingsPlanForm()
    }
}


