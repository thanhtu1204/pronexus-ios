//
//  PerformanceSection.swift
//  ProNexus
//
//  Created by Tú Dev app on 04/11/2021.
//

import SwiftUI

struct PerformanceSection: View {
    var title = ""
    @EnvironmentObject var service: ProviderApiService
    @State var resultsTotalIncom: TotalProviderIncome?
    @State var loading = true
    @State var selection: Int = 0
    
    var body: some View {
        VStack {
            SectionTitleDropdown(title: title, selection: $selection.onUpdate {
                if selection == 0 {                
                    loadData()
                }
                if selection == 7 {
                    let startDate = Date().adjust(.day, offset: -7).toString(format: .custom("yyyy/M/dd"))
                    let endDate = Date().toString(format: .custom("yyyy/M/dd"))
                    
                    loadData(startDate: startDate, endDate: endDate)
                }
                if selection == 30 {
                    let startDate = Date().adjust(.day, offset: -30).toString(format: .custom("yyyy/M/dd"))
                    let endDate = Date().toString(format: .custom("yyyy/M/dd"))
                    loadData(startDate: startDate, endDate: endDate)
                }
            }).padding(.horizontal, 37).padding(.top, 20)
            if let item = resultsTotalIncom {
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack (spacing: 5) {
                        ItemPerform(image:"person.3.fill", title: "Khách hàng", description:"\(item.totalCustomer)+", iconClor: "#1D74FE")
                        ItemPerform(image:"clock.fill", title: "Số giờ tư vấn", description:"\(item.adviseHours)+", iconClor:"#49D472")
                        ItemPerform(image:"dollarsign.circle.fill", title: "Doanh thu", description: String(item.totalAmount).convertDoubleToCurrencyK(), iconClor:"#EFCE4F")
                        ItemPerform(image:"creditcard.fill", title: "Số dư", description: String(item.amount).convertDoubleToCurrency(), iconClor:"#A27CEB")
                    }.padding(.vertical, 5)
                }).padding(.leading, 37)
            } else
            {
                NoData()
            }
        }.onAppear {
            loadData()
        }
    }
    
    func loadData(startDate: String = "", endDate: String = "")
    {
        self.loading = true
        _ = service.loadTotalProviderIncome(startDate: startDate, endDate: endDate).done { TotalProviderIncomeList in
            if let items = TotalProviderIncomeList.payload {
                self.resultsTotalIncom = items
            }
            self.loading = false
        }
    }
}


struct PerformanceSection_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}
