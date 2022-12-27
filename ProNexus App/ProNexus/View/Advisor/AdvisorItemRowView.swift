//
//  AdvisorItemRowView.swift
//  ProNexus
//
//  Created by Tú Dev app on 07/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import WrappingHStack

struct AdvisorItemRowView: View {
    @State var favorite = false
    var item: AdvisorModel
    @EnvironmentObject var service: ProviderApiService
    @Binding var advisorId: String

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
                                Image("ic_picture_circle").resizable().scaledToFit().frame(width: 70, height: 70)
                            }
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                        
                    }
                }.onTapGesture {
                    self.advisorId = String(item.id ?? 0)
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
                        self.advisorId = String(item.id ?? 0)
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
                        if let advisorID = item.id {
                            _ = service.deleteAdvisorFavorite(id: String(advisorID))
                        }
                    }else{
                        self.favorite = true
                        if let advisorID = item.id {
                            let data: [String: Any] = [
                                "ProviderId": item.id ?? ""
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
            //check advisor is favorite
            _ = service.checkAdvisorFavorite(id: String(self.item.id ?? 0)).done { CommonResponseModel in
                self.favorite = CommonResponseModel.ok
            }
        }
        
    }
}

struct AdvisorItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAdvisorView().environmentObject(ProviderApiService()).environmentObject(ClassificationApiService())
    }
}
