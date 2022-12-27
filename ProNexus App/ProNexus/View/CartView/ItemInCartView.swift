//
//  ItemInCartView.swift
//  ProNexus
//
//  Created by Tú Dev app on 11/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine
struct ItemInCartView: View {
    
    var item: ProductElement
    
    @State var message = ""
    @Binding var isShowDelete: Bool
    @Binding var itemIdSelected: Int
    @Binding var itemIdPreview: Int
    @State var isShowAlertError = false
    @State var isChecked: Bool = false
//    @Binding var isSelectAll: Bool
    
    @EnvironmentObject var service: MarketPlaceApiService
    
    var body: some View {
        ZStack (alignment: .leading) {
            Button {
                self.itemIdPreview = item.productCartId ?? 0
            } label: {
                Image(systemName: (item.isChecked ?? false) ? "checkmark.square" : "square").foregroundColor(Color.gray)
            }.zIndex(99)
            
            HStack (){
                
                VStack{
                    WebImage(url: URL(string: item.productImageFirst())).resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 152)
                        .clipped()
                }
                
                VStack (alignment: .leading) {
                    HStack (alignment: .center, spacing: 0.0) {
                        HStack{
                            Text("\(item.productCategoryName ?? (item.organizationName ?? ""))")
                                .italic()
                                .appFont(style: .body, size: 10, color: Color(hex: "#1D74FE"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .foregroundColor(Color(hex: "#1D74FE"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(hex: "#1D74FE"), lineWidth: 0.2))
                        }
                        Spacer()
                        HStack{
                            //                            Button(action: {  }) {
                            //                                CircleButtonProductCart(icon: "heart", color: Color(hex: "#808080"))
                            //                            }
                        }
                    }
                    .padding(.trailing,17)
                    .padding(.leading, 10)
                    
                    Text("\(item.name ?? "")"[0..<60])
                        .appFont(style: .body, size: 12)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame( height: 50)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    HStack{
                        Text("\(item.price ?? 0) đ")
                            .appFont(style: .title1, weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                        
                        Text("-\(item.pricePercentDiscount ?? 0) %").font(.system(size: 12))
                            .padding(.vertical,3)
                            .padding(.horizontal,5)
                            .foregroundColor(.white)
                            .background(Color(.red))
                            .cornerRadius(12)
                        
                        Spacer()
                        
                        HStack{
                            Button("Xoá") {
                                self.itemIdSelected = item.productCartId ?? 0
                                self.isShowDelete = true
                            }
                            .appFont(style: .body, size: 12, color: Color(hex: "#50A0FC"))
                        }
                    }
                    .padding(.trailing, 17)
                    .padding(.leading, 10)
                }
                .padding(.vertical, 17)
                
                
            }
            
            .frame(height: 152)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.leading, 30)
            .padding(.top, 5)
            .myShadow()
            
        }
//        .onReceive(Just(isSelectAll)) {    // << subscribe
//            print(">> isSelectAll: \($0)")
//            if self.isSelectAll == true {
//                self.isChecked = true
//            } else
//            {
//                self.isChecked = false
//            }
//        }
        
    }
    
    
}

struct CircleButtonProductCart: View {
    
    var icon = "person.crop.circle"
    var color = Color("button")
    
    var body: some View {
        return VStack {
            Image(systemName: icon)
                .foregroundColor(color)
        }
        .frame(width: 25, height: 25)
        .background(Color("button"))
        .cornerRadius(30)
        .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
    }
}


struct ItemInCartView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(itemIdSelected: 0, itemIdPreview: 0).environmentObject(MarketPlaceApiService())
    }
}
