//
//  ItemConfirmOrderView.swift
//  ProNexus
//
//  Created by Tú Dev app on 11/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct ItemConfirmOrderView: View {
    
    var item: ProductElement
    
    var body: some View {
        HStack{
            VStack{
                WebImage(url: URL(string: item.productImageFirst())).resizable()
                    .scaledToFill()
                    .frame(width: 112, height: 152)
                    .clipped()
            }
            
            VStack {
                HStack (alignment: .center) {
                    HStack{                        
                        Text("\(item.productCategoryName ?? (item.organizationName ?? ""))")
                            .italic()
                            .font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .foregroundColor(Color(hex: "#1D74FE"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "#1D74FE"), lineWidth: 1))
                        
                    }

                    Spacer()
                    
//                    HStack{
//                        Button(action: {  }) {
//                            CircleButtonProductCart(icon: "heart", color: Color(hex: "#808080"))
//                        }
//                    }
                }
                .padding(.leading,10)
                .padding(.trailing,17)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    //                if let des = item.title {
                    Text("\(item.name ?? "")"[0..<60]).appFont(style: .body, size: 12).lineLimit(2)
                    //                }
                }
                .padding(.leading,10)
                .padding(.trailing,17)
                
                Spacer()
                
                HStack{
                    Text("\(item.price ?? 0) đ")
                        .appFont(style: .title1, weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                    
                    Text("-\(item.pricePercentDiscount ?? 0) %").font(.system(size: 12))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .foregroundColor(.white)
                        .background(Color(.red))
                        .cornerRadius(12)
                    
                    Spacer()
                    
                        Text("x1")
                        .appFont(style: .body, size: 12, color: Color(hex: "#808080"))
                }
                .padding(.leading,10)
                .padding(.trailing,17)

            }
        }
        .padding(.vertical, 17)
        .frame(width: screenWidth()-74,height: 152)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
    }
}


//struct ItemConfirmOrderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemConfirmOrderView()
//    }
//}
