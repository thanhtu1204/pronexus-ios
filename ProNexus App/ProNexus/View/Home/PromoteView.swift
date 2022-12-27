//
//  PromoteView.swift
//  ProNexus
//
//  Created by Tú Dev app on 04/11/2021.
//

import SwiftUI
import ACarousel
import SDWebImageSwiftUI

struct PromoteView: View {
    @State var loading = true
    @State var currentIndex: Int = 0
    @State var banners: [BannerModel] = []
    @State var viewTitle = true

    // Offset...
    @GestureState var offset: CGFloat = 0
    
    // Properties...
    var spacing: CGFloat = 37
    var trailingSpace: CGFloat = 74
    
    @State var index: Int = 0
    
    @EnvironmentObject var service: BannerService
    
    var body: some View {
        VStack {
            if (self.viewTitle == true ){
                SectionTitleView(title: "Ưu đãi", nextView: CouponsListView().navigationBarHidden(true).navigationBarBackButtonHidden(true)
                
                ).padding(.horizontal, 37)
            }
            
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
            } else
            {
                if let items = banners {
                    if items.count > 0 {
                        ACarousel(items,
                                  spacing: 10,
                                  headspace: 10,
    //                              sidesScaling: 1.0,
                                  isWrap: false) { item in
                            if let image = item.mediaURL
                            {
                                VStack {
                                    WebImage(url: URL(string: image))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: screenWidth() - 74 ,height: 170)
                                        .cornerRadius(15)
                                }.contentShape(Rectangle())
                                    .onTapGesture {
                                        if let url = URL(string: item.bannerURL ?? "") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                            }
                            
                        }
                        .frame(width: screenWidth(), height: 170)
                    } else
                    {
                        NoData()
                    }
                }
                else
                {
                    //display no data
                    NoData()
                }
            }
        }.onAppear {
            self.loading = true
            _ = service.loadListBanners().done { BannersResponse in
                
                if let items = BannersResponse.results {
                    self.banners = items
                }
                self.loading = false
            }
            
        }.offset(x: 0, y: 10)
        
    }
}



struct SectionPromorion_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserApiService()).environmentObject(ProviderApiService())
    }
}
