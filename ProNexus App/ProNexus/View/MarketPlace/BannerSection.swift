//
//  BannerSection.swift
//  ProNexus
//
//  Created by Tú Dev app on 08/11/2021.

import SwiftUI
import ACarousel
import SDWebImageSwiftUI

struct BannerSection: View {
    
    @State var currentIndex: Int = 0
    @State var banners: [BannerModel] = []
    // Offset...
    @GestureState var offset: CGFloat = 0
    
    // Properties...
    var spacing: CGFloat = 37
    var trailingSpace: CGFloat = 74
    
    @State var index: Int = 0
    
    @EnvironmentObject var bannerService: BannerService
    
    var body: some View {
        VStack {
            if let list = bannerService.bannerList.results
            {
                if list.count > 0 {
                    ACarousel(list,
                              spacing: 10,
                              headspace: 10,
                              isWrap: false) { item in
                        if let image = item.mediaURL
                        {
                            WebImage(url: URL(string: image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth() - 74 ,height: 170)
                                .cornerRadius(15)
                        }
                        
                    }
                    .frame(width: screenWidth(), height: 170)
                }
            }
        }.onAppear {
            _ = bannerService.loadListBanners().done { BannersResponse in
                //                self.banners = bannerService.bannerList.results ?? []
            }
            
        }.offset(x: 0, y: 10)
        
    }
}



struct BannerSection_Previews: PreviewProvider {
    static var previews: some View {
        BannerSection()
    }
}
