//
//  CustomerConnectedView.swift
//  ProNexus
//
//  Created by Tú Dev app on 27/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomerConnectedView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var loading = true
    @State var results: [CustomerConnected] = []
    @EnvironmentObject var service : ProviderApiService
    
    var body: some View {
        VStack{
        ZStack(alignment: .center) {
            HStack(spacing: 0) {
                //button left
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                }).frame(width: 50, alignment: .center).padding(.leading, 27)
                
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    Text("Khách hàng đã tư vấn")
                        .appFont(style: .body,weight: .regular, size: 20, color: Color(.white))
                }.offset(x: -20, y: 0)
                
                Spacer()
            }
        }.background(
            Image("bg_header")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.screenWidth, height: 180)
                .edgesIgnoringSafeArea(.top)
        ).offset(y: -4)
                .padding(.bottom,40)
            
        ScrollView(showsIndicators:false){
            VStack{
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else
                {
                    if let items = results {
                        VStack{
                            ForEach (items){item in
                                CustomerConectedItem(item:item)
                            }
                        }.padding(.top,32)
                    }else{
                        NoData()
                    }
                }
                
                
            }
        }.onAppear{
            self.loading = true
            _ = service.loadListCustomerConected().done { CustomerConnectedList in
                if let items = CustomerConnectedList.payload {
                    self.results = items
                }
                self.loading = false
            }
        }
    }
        Spacer()
    }
}

struct CustomerConectedItem: View {
    @State var favorite = false
    var item : CustomerConnected
    
    var body: some View {
            ZStack (alignment: .topTrailing) {
                HStack(alignment: .center, spacing: 15){
                    VStack(alignment: .center){
                        if let image = item.mediaURL{
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
                            if let advisorName = item.fullName {
                                Text(advisorName).appFont(style: .body, weight: .bold, size: 13, color: Color(hex: "#4D4D4D")).fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
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
                            
                            HStack{
                                Image(systemName: "star.fill").resizable().frame(width: 10, height: 10).foregroundColor(Color(hex: "#FFC700"))
                                if let rating = item.rating{
                                    Text(String(rating))
                                        .myFont(style: .body,size: 10, color: Color(hex: "#808080"))
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                HStack (alignment: .center) {
                    Button(action: {
                    }) {
                        HStack{
                            Text("Đánh giá")
                                .myFont(style: .body, size: 10, color:
                                            Color(hex: "#FFFFFF") )
                        }
                    }.buttonStyle(YellowButton(w: 80, h: 25))
                }.padding(.top,10)
            }
            .padding(.horizontal, 18).padding(.vertical,17)
            .frame(width: screenWidth()-74, height: 106)
            .background(Color.white)
            .cornerRadius(15)
            .myShadow()
        }
    
}

struct CustomerConnectedView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerConnectedView().environmentObject(ProviderApiService())
    }
}
