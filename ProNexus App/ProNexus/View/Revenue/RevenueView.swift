//
//  RevenueView.swift
//  ProNexus
//
//  Created by Tuyen on 10/31/21.
//

import Foundation

import Combine
import SwiftUI

struct RevenueView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State var loading = true
    @State var loadingIncomList = true
    @State var resultsTotalIncom: TotalProviderIncome?
    @State var resultsIncomList: [ProviderIncome] = []
    @State var resultsChartList: [ProviderIncome] = []
    @State var values: [BarChartData2] = []
    @State var selectMonth = ""
    
    @State var expand = false
    
    @EnvironmentObject var service : ProviderApiService
    
    var body: some View {
        VStack {
            VStack {
                // HEADER
                ZStack(alignment: .center) {
                    HStack(spacing: 0) {
                        //button left
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }).frame(width: 50, alignment: .center)
                        
                        Spacer()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Text("Doanh thu").regular(size: 20, color: Color.white)
                    }
                }.background(
                    Image("bg_header_home")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth, height: 238)
                        .edgesIgnoringSafeArea(.top)
                ).offset(x: 0, y: -4)
                
                
            }
            
            
            
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center).padding(.top, 50)
            } else
            {
                if let items = resultsTotalIncom {
                    VStack (alignment: .center, spacing: 15){
                        //                        Text("\(String(format: "%.0f", items.totalAmount)) VNĐ")
                        Text(String(items.totalAmount).convertDoubleToCurrency())
                            .appFont(style: .body, weight: .bold, size: 28, color: Color(hex: "#50A0FC"))
                        Text("Số dư khả dụng").appFont(style: .title1)
                    }
                    .frame(width: 280, height: 115)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow()
                    
                    VStack (alignment: .center, spacing: 15){
                        HStack () {
                            Image("ic_money").resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            VStack (alignment: .leading, spacing: 8) {
                                Text("Số dư chờ rút").appFont(style: .body, color: Color(hex: "#4D4D4D"))
                                Text("\(String(items.requestAmount).convertDoubleToCurrency())")
                                    .myFont(style: .body, weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                            }
                        }
                        HStack {
                            //                            Button(action: {}, label: {
                            //                                Badge(text: "Lịch sử rút tiền", textColorHex: "#50A0FC", bgColorHex: "#fff")
                            //                            })
                            NavigationLink {
                                WithdrawalHistoryView().navigationBarHidden(true).navigationBarBackButtonHidden(true).environmentObject(ProviderApiService())
                            } label: {
                                Badge(text: "Lịch sử rút tiền", textColorHex: "#50A0FC", bgColorHex: "#fff")
                            }
                            NavigationLink {
                                WithdrawMoneyForm().navigationBarHidden(true).navigationBarBackButtonHidden(true).environmentObject(ProviderApiService())
                            } label: {
                                Badge(text: "Rút tiền", textColorHex: "#fff", bgColorHex: "#50A0FC")
                            }
                        }
                        
                    }
                    .frame(width: UIScreen.screenWidth - 60, height: 115)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow()
                    .padding(.vertical, 15)
                }
                else {
                    NoData()
                }
            }
            
            ScrollView(showsIndicators: false) {
                 
                
                // biểu đồ
                
                ZStack (alignment: .top){
                    VStack {
                        Text("Doanh thu theo tháng").bold(size: 16, color: Color(hex: "#4D4D4D")).padding(.top, 20)
                        Divider().padding(.bottom, 10)
                        VStack{
                            HStack {
                                Text(self.selectMonth == "" ? "Tháng hiện tại" : self.selectMonth).appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080"))
                                
                                Image(systemName: expand ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill").resizable().frame(width: 8, height: 6).foregroundColor(.gray)
                            }.onTapGesture{
                                self.expand.toggle()
                            }
                            if expand {
                                ScrollView (showsIndicators: false) {
                                    ForEach(-6..<7, id: \.self) { index in
                                        let monthName = "Tháng \(Date().adjust(.month, offset: index).toString(format: .custom("MM/yyyy")))"
                                        Text(monthName).appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080")).onTapGesture {
                                            selectMonth = monthName
                                            self.expand.toggle()
                                            let startDate = Date().adjust(.month, offset: index).dateFor(.startOfMonth).toString(format: .custom("yyyy/M/dd"))
                                            let endDate = Date().adjust(.month, offset: index).dateFor(.endOfMonth).toString(format: .custom("yyyy/M/dd"))
                                            loadListProviderIncomeByDone(start: startDate, end: endDate)
                                            
                                        }.padding(.all, 5)
                                    }
                                }.frame(maxHeight: 150)
                            }
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .frame(minWidth: 130, alignment: .top)
                        .background(Color.white)
                        .cornerRadius(15)
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color(hex: "#808080"),lineWidth:0.5))
                        .alignmentGuide(VerticalAlignment.firstTextBaseline) { $0[.top] }    // << here !!
                    }.zIndex(999)
                    
                    // chart
                    VStack {
                        if let values = values {
                            if values.count > 0
                            {
                                BarChart(title: "Monthly Sales", legend: "EUR", barColor: Color(hex: "#FFC700"), data: values)
                            } else
                            {
                                Spacer()
                                NoData()
                                Spacer()
                            }
                        }
                    }.padding(.top, 100)
                }
                .frame(width: UIScreen.screenWidth - 74, height: 300)
                .background(Color.white)
                .cornerRadius(15)
                .myShadow()
                .padding(.horizontal, 2)
                .padding(.vertical, 15)
                
                if $loadingIncomList.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else {
                    
                    if let items = resultsIncomList {
                        VStack(alignment: .leading, spacing: 15) {
                                                        
//                            ScrollView(.vertical, showsIndicators: false) {
//
//                            }
                            ForEach(items){item in
                                VStack {
                                    HStack(alignment: .center, spacing: 15){
                                        Image("ic_cash").resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                        
                                        VStack{
                                            HStack{
                                                
                                                VStack(alignment: .leading, spacing: 10, content: {
                                                    
                                                    if let name = item.customerName{
                                                        Text(name).appFont(style: .body)
                                                    }
                                                    
                                                    if let totalAmount = item.finalAmount {
                                                        Text("+ \(String(totalAmount).convertDoubleToCurrency())")
                                                            .appFont(style: .body, weight: .bold, color: Color(hex: "#4d4d4d"))
                                                    }
                                                    
                                                })
                                                Spacer(minLength: 10)
                                                if let createdOn = item.createdOn{
                                                    VStack(alignment: .trailing) {
                                                        Text("\((Date(fromString: createdOn[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy")))!)")
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                            .padding(.top,5)
                                                        Spacer()
                                                    }
                                                }
                                                
                                            }
                                            
                                        }.padding(.vertical, 5)
                                        
                                    }
                                    Divider()
                                }.padding(.horizontal,20)
                                    .padding(.top,10)
                            }
                        }
                        //                    .offset(y: 30)
                        .frame(width: UIScreen.screenWidth - 60)
                        .background(Color.white)
                        .cornerRadius(15)
                        .myShadow()
                        .padding(.horizontal, 33)
                    } else{
                        NoData()
                    }
                }
            }
            
            
            
            Spacer()
        }
        .onAppear{
            loadData()
        }
    }
    func loadData(){
        self.loading = true
        self.loadingIncomList = true
        
        //GET Tổng doanh thu của advisor đang login
        _ = service.loadTotalProviderIncome().done { TotalProviderIncomeList in
            if let items = TotalProviderIncomeList.payload {
                self.resultsTotalIncom = items
            }
            self.loading = false
        }
        
        // lịch sử công tiền doanh thu
        _ = service.loadListProviderIncome().done{ProviderIncomeList in
            if let items = ProviderIncomeList.payload {
                self.resultsIncomList = items
            }
            self.loadingIncomList = false
            
        }
        // biểu đồ doanh thu
        
        loadListProviderIncomeByDone()
    }
    
    func loadListProviderIncomeByDone(start: String = "", end: String = "") {
        _ = service.loadListProviderIncomeByDone(startDate: start, endDate: end).done({ ProviderIncomeList in
            if let items = ProviderIncomeList.payload {
                self.resultsIncomList = items
                self.values = []
                for item in self.resultsIncomList {
                    let label = (Date(fromString: item.dateTime![0..<11], format: .isoDate)?.toString(format: .custom("dd/M")))
                    values.append(BarChartData2(label: label!, value: (item.finalAmount ?? 0), display: (item.finalAmount ?? 0)))
                }
            }
        })
    }
}

struct RevenueView_Preview: PreviewProvider {
    static var previews: some View {
        //        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
        RevenueView().environmentObject(ProviderApiService())
    }
}
