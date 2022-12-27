//
//  AdvisorConectedView.swift
//  ProNexus
//
//  Created by Tú Dev app on 15/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct AdvisorConectedView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var loading = true
    @State var results: [AdvisorModel] = []
    @EnvironmentObject var service : ProviderApiService
    
    var body: some View {
        ScrollView(showsIndicators:false){
            VStack{
                Header(title: "Cố vấn đã kết nối", contentView: {
                    ButtonIcon(name: "arrow.left", onTapButton: {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    })
                    Spacer()
                })
                
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else
                {
                    if let items = results {
                        VStack{
                            ForEach (items){item in
                                AdvisorConectedItem(item:item)
                            }
                        }.padding(.top,32)
                    }else{
                        NoData()
                    }
                }
                
                
            }
        }.onAppear{
            self.loading = true
            _ = service.loadListProviderConected().done { rs in
                if let items = rs.results {
                    self.results = items
                }
                self.loading = false
            }
        }
    }
}

struct AdvisorConectedItem: View {
    @State var favorite = false
    var item : AdvisorModel
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            HStack(alignment: .center, spacing: 15){
                VStack(alignment: .center){
                    if let image = item.mediaUrl{
                        WebImage(url: URL(string: image))
                            .resizable()
                            .onSuccess { image, data, cacheType in
                                // Success
                                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                            }
                            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                            .placeholder {
                                Image("ic_picture_circle").resizable().scaledToFit()
                            }
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                        
                    }
                }
                VStack(alignment: .leading){
                    HStack{
                        if let advisorName = item.fullName() {
                            Text(advisorName).appFont(style: .body, weight: .bold, size: 13, color: Color(hex: "#4D4D4D")).fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                    
                    HStack{
                        if let jobTitle = item.jobTitle{
                            Text(jobTitle).appFont(style: .body, weight: .regular, size: 12, color: Color(hex: "#4D4D4D"))
                        }
                        
                    }
                    
                    
                    HStack{
                        HStack (alignment: .center, spacing: 0.0) {
                            Image( "ic_location")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.gray)
                                .frame(width:6,height: 8).padding(.trailing,6)
                            if let province = item.province {
                                Text("\(province)").appFont(style: .body, size: 10)
                            }
                        }
                        
                        HStack{
                            Divider().frame(height:10)
                        }

                        
                        HStack (alignment: .center, spacing: 0.0) {
                            Image( "ic_dollar")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.gray)
                                .frame(width:6,height: 8).padding(.trailing,6)
                            if let priceHours = item.priceHours{
                                Text("\(priceHours)đ/h").appFont(style: .body, size: 10)
                            }
                        }
                        
                        HStack{
                            Divider().frame(height:10)
                        }

                        HStack{
                            Image(systemName: "star.fill").resizable().frame(width: 10, height: 10).foregroundColor(Color(hex: "#FFC700"))
                            if let rating = item.advisorAvgRate() {
                                Text(String(format: "%.1f", rating))
                                    .myFont(style: .body,size: 10, color: Color(hex: "#808080"))
                            }
                        }
                        
                    }
                    HStack{
                        Button(action: {
                        }) {
                            HStack{
                                Text("Giới thiệu")
                                    .myFont(style: .body, size: 10, color: Color(hex: "#4C99F8") )
                            }
                        }.buttonStyle(BorderButton(isSelected: true, w: 80, h: 25))
                        .padding(.vertical,5)
                        
                        NavigationLink {
                            AdvisorReviewsView(providerId :item.id ?? 0, imgURL:item.mediaUrl ?? "", fullName:item.fullName(),jobTitle: item.jobTitle ?? "").environmentObject(ProviderApiService())
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true)
                        } label: {
                            HStack{
                                Text("Đánh giá")
                                    .myFont(style: .body, size: 10, color:
                                                Color(hex: "#FFFFFF") )
                            }
                            
                        }.buttonStyle(YellowButton(w: 80, h: 25))
                        
                    }
                    //                    if let list = item.classificationList
                    //                    {
                    //                        HStack {
                    //                            ForEach(list) { item in
                    //                                Badge(text: item.name ?? "", textColorHex: "#fff", bgColorHex: "", textSize: 12.0)
                    //                            }
                    //                        }
                    //                    }
                }
                
            }
            
            
            HStack (alignment: .top) {
                Button(action: {}, label:{
                    Image(systemName: "chevron.right").resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(width:17,height: 15).padding(.leading,0)
                }).offset(x: 0, y: 20)
            }
            
            
        }
        .padding(.horizontal, 18).padding(.vertical,17)
        .frame(width: screenWidth()-74, height: 140)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
        .offset(x: 0, y: 30)
        
    }
}


struct AdvisorConectedView_Previews: PreviewProvider {
    static var previews: some View {
        AdvisorConectedView().environmentObject(ProviderApiService())
    }
}
