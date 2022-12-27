//
//  ListAdvisorFavorite.swift
//  ProNexus
//
//  Created by thanh cto on 04/12/2021.
//

import Foundation
import SwiftUI
import WrappingHStack
import SDWebImageSwiftUI

struct ListAdvisorFavorite: View {
    
    @ObservedObject var vm = SearchAdvisorViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @State var selectedTab = "0"
    @EnvironmentObject var service: ProviderApiService
    @EnvironmentObject var serviceClassificationList: ClassificationApiService
    @State var classificationList = [ClassificationModel]()
    @State var selections: [Int] = []
    @State var results: [AdvisorFavoriteItem] = []
    @State private var showingSheet = false
    @State var loading = true
    @State var loadingMore = false
    @State var navAdvisorDetail = false
    @State var advisorId: String = ""
    
    @State var provinceId: Int?
    @State var isSelectedStar:String = ""
    @State var isSelectedPrice:String = ""
    @State var starSelections : [String] = []
    
    @State var page: Int = 1
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    Header(title: "Cố vấn yêu thích", contentView: {
                        ButtonIcon(name: "arrow.left", onTapButton: {
                            self.presentationMode.wrappedValue.dismiss()
                            
                        })
                        Spacer()
                    })
                    
                
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        VStack {
                            if $loading.wrappedValue {
                                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                            } else
                            {
                                if let items = results {
                                    ScrollView(.vertical, showsIndicators: false, content: {
                                        VStack(spacing: 15){
                                            if let results = results {
                                                
                                                ForEach(results) {item in
                                                    AdvisorItemRowFavoriteView(item: item, advisorId: $advisorId.onUpdate {
                                                        self.navAdvisorDetail = true
                                                    })
                                                }
                                            }
                                            
                                        }
                                        .padding(.horizontal, 37)
                                        .padding(.top, 10)
                                        .padding(.bottom, 30)
                                    })
//                                        .frame( height: 510)
                                    
                                    if $navAdvisorDetail.wrappedValue {
                                        NavigationLink(destination:
                                                        AdvisorDetailView(id: advisorId).environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true), isActive: $navAdvisorDetail)
                                        {
                                            EmptyView()
                                        }
                                    }
                                    
                                    
                                    HStack(spacing: 0) {
                                        Spacer()
                                        if $loadingMore.wrappedValue {
                                            SectionLoader().frame(width: screenWidth() - 74, height: 20, alignment: .center)
                                        } else
                                        {
                                            Button(action: {
                                                self.page += 1
                                                self.loadMoreData(page:self.page)
                                            }, label: {
                                                Image(systemName: "chevron.down")
                                                    .foregroundColor(Color(hex: "#B3B3B3")
                                                    )
                                            }).frame(width: screenWidth() - 74, height: 20, alignment: .center)
                                        }
                                        Spacer()
                                    }.padding(.vertical, 0)
                                    
                                }
                                else
                                {
                                    NoData()
                                }
                            }
                            
                            Spacer()
                        }.padding(.bottom, 5)
                            .onAppear{
                                
                                // load danh sách cô vấn
                                self.loadData()
                                
                            }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    }
//                    .edgesIgnoringSafeArea(.bottom)
                        .padding(.top, 40)
                        .zIndex(12)
                }
            }
        }
    }
    
    
    func loadData(type: String = ""){
        self.loading = true
        // danh sach co van
        _ = service.loadListProviderFavorite(size: 20).done { ProviderListModel in
            if let items = ProviderListModel.payload {
                self.results = items
            }
            self.loading = false
        }
    }
    
    func loadMoreData(type: String = "", page:Int = 1){
        self.loadingMore = true
        // danh sach co van yeu thich
        _ = service.loadListProviderFavorite(page: page).done { rs in
            if let items = rs.payload {
                results.append(contentsOf:items)
            }
            self.loadingMore = false
        }
    }
    
    
}


struct AdvisorItemRowFavoriteView: View {
    @State var favorite = false
    var item: AdvisorFavoriteItem
    @EnvironmentObject var service: ProviderApiService
    @Binding var advisorId: String

    var body: some View {
        ZStack (alignment: .topTrailing) {
            HStack(alignment: .center, spacing: 15){
                VStack(alignment: .center){
                    if let image = item.mediaURL {
                        WebImage(url: URL(string: image))
                            .resizable()
                            .onSuccess { image, data, cacheType in
                                // Success
                                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                            }
                            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                            .placeholder {
                                Image("ic_picture_circle").resizable().scaledToFit().frame(width: 70, height: 70)
                            }
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                        
                    }
                }.onTapGesture {
                    self.advisorId = String(item.advisorID ?? 0)
                }
                
                VStack(alignment: .leading) {
                    HStack{
                        if let advisorName = item.fullName() {
                            Text("\(advisorName)").appFont(style: .body, weight: .bold, size: 13, color: Color(hex: "#4D4D4D"))
                                .multilineTextAlignment(.leading)
//                                .fixedSize(horizontal: true, vertical: false)
                        }
                        Spacer()
                        if let rating = item.advisorAvgRate() {
                            StarsView(rating: Float(rating)).padding(0)
                            Text(String(format: "%.1f", rating)).appFont(style: .body, weight: .regular, size: 8, color: .black)
                        }
                    }.onTapGesture {
                        self.advisorId = String(item.advisorID ?? 0)
                    }
                    
                    HStack{
                        if let jobTitle = item.jobTitle{
                            Text("\(jobTitle)").appFont(style: .body, weight: .regular, size: 12, color: Color(hex: "#4D4D4D"))
                        }

                    }

                    if let list = item.classificationList
                    {
                        WrappingHStack(0..<list.count) { index in
                            let item = list[index]
                            Badge(text: item.name ?? "", textColorHex: "#fff", bgColorHex: "", textSize: 12.0).fixedSize(horizontal: false, vertical: true).padding(.bottom, 6)
                        }.padding(.trailing, 20)
                    }
                }
                                
            }
                    
            
            HStack (alignment: .top) {
                Button(action: {
                    if(self.favorite){
                        self.favorite = false
                        if let advisorID = item.advisorID {
                            _ = service.deleteAdvisorFavorite(id: String(advisorID))
                        }
                    }else{
                        self.favorite = true
                        if let advisorID = item.advisorID {
                            let data: [String: Any] = [
                                "ProviderId": item.advisorID ?? ""
                            ]
                            _ = service.advisorFavorite(parameters: data)
                        }
                    }
                }, label:{
                    
                    Image(systemName: favorite ? "heart.fill" : "heart").resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(width:17, height: 15).padding(.leading,0)
                    
                }).offset(x: 0, y: 50)
            }
    
        }
        .padding(.horizontal, 18).padding(.vertical,17)
//        .frame(width: screenWidth()-74, minHeight: 106)
        .frame(minWidth: containerWidth(), minHeight: 106, alignment: .leading)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
        .onAppear() {
            //check product is favorite
            _ = service.checkAdvisorFavorite(id: String(self.item.advisorID ?? 0)).done { CommonResponseModel in
                self.favorite = CommonResponseModel.ok
            }
        }
        
    }
}

struct ListAdvisorFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        ListAdvisorFavorite().environmentObject(ProviderApiService()).environmentObject(ClassificationApiService())
    }
}
