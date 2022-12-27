//
//  RetiremantPlan-TableAndChartView.swift
//  ProNexus
//
//  Created by TUYEN on 11/28/21.
//

import SwiftUI
import Charts

struct RetiremantPlan_TableAndChartView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var tabIndex = 0
    @State var model: RetiementPlan?
    @State var isRender = false
    @State var set1: [BarChartDataEntry] = []
    @State var set2: [BarChartDataEntry] = []
    
    var body: some View {
        VStack(spacing: 25) {
            Header(title: "Kế hoạch nghỉ hưu", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                Spacer()
            })
                .padding(.bottom, 15)
            
            
            ScrollView() {
            
                VStack {
                    VStack(alignment: .leading) {
                        VStack (alignment: .center){
                            Group () {
                                Text("Để nghỉ hưu khi")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(" \(model?.retirementAge ?? 0) tuổi")
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                + Text(" với thu nhập hàng năm hiện tại là ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text("\(model?.income ?? 0)".convertDoubleToCurrency())
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                + Text(" thì mỗi năm bạn cần tiết kiệm thêm")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                            }
                            Group () {
                                Text("\(model?.extraSavings ?? 0)".convertDoubleToCurrency())
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                + Text(" tương đương với ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%.1f", (model?.percentOfIncome ?? 0) * 100))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                + Text(" % ")
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                + Text("thu nhập. Số tiền bạn có được khi nghỉ hưu là ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                +  Text("\(model?.retirementAmount ?? 0)".convertDoubleToCurrency())
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                            }
                        }
                        
                    }
                    .padding(.all, 20)
                    .frame(width: UIScreen.screenWidth - 74)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow()
                    
                    Spacer(minLength: 20)
                             
                    VStack () {
                        TabBar(tabIndex: $tabIndex)
                            .frame(width: UIScreen.screenWidth - 74)
                        if tabIndex == 1 {
                            if let charts = model?.charts {
                                TableView(data: charts)
                            }
                            
                        }
                        if tabIndex == 0 {
                            BarCharRetirenmantToolsView(set1: $set1, set2: $set2)
                        }
        //                if $isRender.wrappedValue {
        //                    ChartView(values: $values)
        //                }
                        
                    }
                    .padding(.all, 0)
                    .frame(width: UIScreen.screenWidth - 74, height: 390)
                    .background(Color("button"))
                    .cornerRadius(10)
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
            .padding(.top,36)
            .padding(.all,2)
            
            Spacer()
        }.onAppear() {
            buildChart()
        }
    }
    
    
    func buildChart() {
        self.set1.removeAll();
        self.set2.removeAll();
        if let charts = model?.charts {
            charts.forEach { item in
                let save = Double((item.save ?? 0)) / 1000000
                let retirementIncome = Double((item.retirementIncome ?? 0)) / 1000000
                print("save", save)
                print("retirementIncome", retirementIncome)
                self.set1.append(BarChartDataEntry(x: Double(item.age ?? 0), y: save))
                self.set2.append(BarChartDataEntry(x: Double(item.age ?? 0), y: retirementIncome))
            }
        }
    }
}

struct RetiremantPlan_TableAndChartView_Previews: PreviewProvider {
    static var previews: some View {
        RetiremantPlan_TableAndChartView()
    }
}

struct TabBar: View {
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


struct BarCharRetirenmantToolsView: UIViewRepresentable {

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
            dataSet.label = "Khoản tiết kiệm"
            
            let dataSet2 = BarChartDataSet(entries: set2)
            dataSet2.label = "Lương hưu trí"
            
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
//            uiView.autoScaleMinMaxEnabled = true
            

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
        let parent:BarCharRetirenmantToolsView
        init(parent: BarCharRetirenmantToolsView) {
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
        xAxis.granularity = 10.0
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

struct TableView: View {
    
    @State var data: [Chart]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                Text("Tuổi")
                    .frame(minWidth: 45)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Tiết kiệm tích luỹ")
                    .frame(minWidth: 90)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Lãi")
                    .frame(minWidth: 70)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Lương hưu trí")
                    .frame(minWidth: 80)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Số dư cuối kỳ")
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
                            Text("\(item.age ?? 0)")
                                .frame(width: 45, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text("\(item.firstBalance ?? 0)".convertDoubleToCurrency(symbol: ""))
                                .frame(width: 90, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text("\(item.interest ?? 0)".convertDoubleToCurrency(symbol: ""))
                                .frame(width: 70, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            
                            Text("\(item.retirementIncome ?? 0)".convertDoubleToCurrency(symbol: ""))
                                .frame(width: 80, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            
                            Text("\(item.lastBalance ?? 0)".convertDoubleToCurrency(symbol: ""))
                                .frame(width: 80, alignment: .trailing)
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

