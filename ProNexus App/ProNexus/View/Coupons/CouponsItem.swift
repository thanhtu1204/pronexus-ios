//
//  CouponsItem.swift
//  ProNexus
//
//  Created by Tú Dev app on 11/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct CouponsItem: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            
            WebImage(url: URL(string: "https://pronexus-media-files.s3-ap-southeast-1.amazonaws.com/public/img/thumbnails/b7nqC8ER49QUq6OI6YpdeGNLSfApzNI7OuCGlZqL.png"))
                .resizable()
                .frame(width: screenWidth(), height: 160)
                .scaledToFit()
            HStack{
                HStack (alignment: .center, spacing: 0.0) {
                    HStack{
                        Text("Giảm -45%").font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color(.red))
                            .cornerRadius(12)
                    }.padding(.leading,20)
                    Spacer()
                    HStack{
                        Button(action: {  }) {
                            VStack {
                                Image(systemName: "heart")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color(hex: "#808080"))
                                    .frame(width: 14, height: 14)
                            }
                            .frame(width: 25, height: 25)
                            .background(Color("button"))
                            .cornerRadius(30)
                            .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
                        }
                        Button(action: {  }) {
                            VStack {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color(hex: "#808080"))
                                    .frame(width: 14, height: 14)
                            }
                            .frame(width: 25, height: 25)
                            .background(Color("button"))
                            .cornerRadius(30)
                            .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
                        }
                    }.padding(.trailing,10)
                }.padding(.top,10)
            }.offset(x:0,y: -140).padding(.leading,20)
            
            HStack{
                HStack (alignment: .center, spacing: 0.0) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(height: 35)
                }.padding(.leading,10)
                VStack(alignment: .leading, spacing: 8) {
                    Text("[E - voucher Người mới] Mã giảm 25k x 02 khoá học Udemy").appFont(style: .body,size: 14,color:Color(hex:"#4D4D4D")).lineLimit(2)
                }
                .padding(.horizontal, 15.0)
            }.offset(x:0,y: -40).padding(.leading,20)
        }
        .frame(width: screenWidth()-37,height: 222)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
    }
    
    
}

struct CouponsItem_Previews: PreviewProvider {
    static var previews: some View {
        CouponsItem()
    }
}
