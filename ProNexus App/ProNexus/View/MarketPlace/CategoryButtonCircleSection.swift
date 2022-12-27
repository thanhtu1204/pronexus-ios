//
//  CategoryButtonCircleSection.swift
//  ProNexus
//
//  Created by Tú Dev app on 08/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryButtonCircleSection: View {
    @EnvironmentObject var service: MarketPlaceApiService
    
    @State var cates: [ProductCategory]?
    
    var body: some View {
        VStack { // boc trong group thi se trinh bay duoc > 10 view
            
            HStack{
//                SectionTitleView(title: "Danh mục", nextView: EmptyView())
                HStack{
                    
                    Text("Danh mục").appFont(style: .title1, weight: .bold)
                    
                    Spacer()
                   
                }
            }.padding(.trailing, 37).padding(.bottom, 0)
//                        ScrollView(.horizontal, showsIndicators: false, content: {
//                            if let items = service.classificationList.results {
//                                HStack {
//                                    ForEach(items) { item in
//                                        NavigationLink {
//                                            SearchAdvisorView(selectedTab:String(item.id ?? 0), selections:[item.id ?? 0]).environmentObject(ProviderApiService())
//                                                .environmentObject(ClassificationApiService())
//                                                .navigationBarHidden(true).navigationBarBackButtonHidden(true)
//                                        } label: {
//                                            ConsultingFieldItem(item: item)
//                                        }
//
//                                    }
//                                }
//                            }
//
//                        })
            ScrollView(.horizontal, showsIndicators: false, content: {
                if let items = self.cates {
                    HStack {
                        ForEach(items) { item in
//                            CircleButtonItem(item:item).padding(2)
                            NavigationLink {
                                ProductListView(selectedTab:String(item.productCategoryID ?? 0),selections: [item.productCategoryID ?? 0]).environmentObject(MarketPlaceApiService())
                                    .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                            } label: {
                                CircleButtonItem(item: item).padding(.trailing, 6)
                            }
                        }
                    }
                }
                
            })
        }.onAppear {
            _ = service.loadCategory().done { ProductCategoryList in
                if let items = ProductCategoryList.payload {
                    self.cates = items
                }
            }
        }
    }
}



struct CircleButtonItem: View {
    let item : ProductCategory
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                WebImage(url: URL(string: item.iconURL ?? "")).resizable()
                    .scaledToFit()
                    .frame(width: 31, height: 31)
                    .padding(0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            // shadows..
            .frame(width: 75, height: 75)
            .background(Color.white)
            .cornerRadius(82/2)
            .myShadow()
            Text(item.name ?? "").appFont(style: .body, weight: .regular, size: 12, color: Color(hex: "#4D4D4D"))
                .frame(maxWidth: .infinity, alignment: .center)
        }.frame(width: 75, height: 106, alignment: .center)
        
    }
    
}

struct CategoryButtonCircleSection_Previews: PreviewProvider {
    static var previews: some View {
        HomeMarketPlaceView().environmentObject(BannerService()).environmentObject(MarketPlaceApiService())
        
    }
}
