//
//  Advisoritem.swift
//  ProNexus
//
//  Created by Tú Dev app on 05/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct Advisoritem: View {
    
    var model = AdvisorModel()
    
    var body: some View {
        ZStack (alignment: .leading) {
            ZStack {
                VStack (alignment: .leading) {
                    
                    Text(model.providerName ?? "").appFont(style: .body, weight: .bold, color: .black).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
//                    if let classificationList = model.classificationList{
//                        ForEach(classificationList){item in
//                            if let name = item.name{
//                                Text("\(name)").appFont(style: .body, size: 12, color: Color(hex: "#4D4D4D"))
//
//                            }
//                        }
//                    }
                    Text(model.jobTitle ?? "").appFont(style: .body, size: 12, color: Color(hex: "#4D4D4D"))
                    
                    
                    HStack () {
                        if let rating = model.advisorAvgRate() {
                            StarsView(rating: 4)
                            Text(String(format: "%.1f", rating)).appFont(style: .body, size: 8)
                        }
                        
                        
                    }.padding(0)
                    
                    Text("Kinh nghiệm").appFont(style: .body, size: 10)
                    if let yearsExperience = model.yearsExperience{
                        Text("\(yearsExperience) năm").appFont(style: .body, size: 12, color: Color(hex: "#4D4D4D"))
                    }
                    
                    Text("Khách hàng").appFont(style: .body, size: 10)
                    if let customerCount = model.customerCount{
                        Text("\(customerCount)+").appFont(style: .body, size: 12, color: Color(hex: "#4D4D4D"))
                    }
                    
                    
                }.padding(.horizontal, 25)
                    .padding(.vertical, 15)
                //                .frame(width: 260, height: 150)
                ZStack (alignment: .bottomTrailing) {
                    
                    Image("bg_profile_advisor").resizable().scaledToFit().frame(width: 140, height: 116).offset(x: 0, y: 0)
                    VStack {
                        if let imgUrl = model.mediaUrl
                        {
                            
                            WebImage(url: URL(string: imgUrl))
                                .resizable()
                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                .scaledToFit()
                                .foregroundColor(.white)
//                                .frame(height: )
                                .padding(.trailing,0)
                        }
                        
                    }
                    .frame(width: 260, height: 150, alignment: .bottomTrailing)
                }
                
            }
            
            
        }.background(Color(hex: "#fff"))
            .frame(width: 260, height: 150)
        // shadows..
            .cornerRadius(15)
            .myShadow()
    }
}
struct Advisoritem_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}
