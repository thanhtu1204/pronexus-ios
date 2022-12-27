//
//  CategoryActionHomeAdvisor.swift
//  ProNexus
//
//  Created by Tú Dev app on 04/11/2021.
//

import SwiftUI

struct CategoryActionHomeAdvisor: View {
    var body: some View {
        VStack {
            HStack {
                NavigationLink {
                    ListAppointmentView().environmentObject(ProviderApiService())
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Lịch hẹn", image: "booking_icon")
                }
                
                NavigationLink {
                    RevenueView().environmentObject(ProviderApiService())
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Doanh thu", image: "find_cs")
                }
                
                NavigationLink {
                    CustomerConnectedView().environmentObject(ProviderApiService())
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Khách hàng", image: "ic_member")
                }
                
            }
            Spacer(minLength: 20)
            HStack {
                NavigationLink {
                    FinancialInstrumentsView().navigationBarHidden(true).navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Công cụ", image: "tooll_icon")
                }

                NavigationLink {
                    HomeMarketPlaceView().environmentObject(BannerService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "MarketPlace", image: "market_icon")
                }

                NavigationLink {
                    NewsHomeView().environmentObject(NewsApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Tin tức", image: "ic_news")
                }

            }
        }.padding(.top)
    }
}



struct CategoryActionHomeAdvisor_Previews: PreviewProvider {
    static var previews: some View {
        CategoryActionHomeAdvisor()
    }
}
