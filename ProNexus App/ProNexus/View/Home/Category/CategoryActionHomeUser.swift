//
//  CategoryActionHomeUser.swift
//  ProNexus
//
//  Created by Tú Dev app on 04/11/2021.
//

import SwiftUI

struct CategoryActionHomeUser: View {
    var body: some View {
        VStack {
            HStack (){
                
                NavigationLink {
                    CategoriesSelectionListView().environmentObject(ClassificationApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Đặt lịch hẹn", image: "booking_icon")
                }
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
            }
            Spacer(minLength: 20)
            HStack (){
                NavigationLink {
    //                NewsHomeView().environmentObject(NewsApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    SearchAdvisorView().environmentObject(ProviderApiService())
                        .environmentObject(ClassificationApiService())
                        .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Tìm cố vấn", image: "find_cs")
                }
                
                NavigationLink {
                    ListAppointmentView().environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Lịch hẹn", image: "booking_icon")
                }
                
                NavigationLink {
                    NewsHomeView().environmentObject(NewsApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                } label: {
                    IconMenu(name: "Kiến thức", image: "knowledge")
                }
            }
        }.padding(.top)
        
    }
}

