//
//  ShoppingPlanView.swift
//  ProNexus
//
//  Created by TUYEN on 12/6/21.
//

import SwiftUI

struct ShoppingPlanView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("bg_login_regsiter").resizable().scaledToFill().offset(x: 0, y: -5)
            VStack(alignment: .center, spacing: 20) {
                HStack{
                    //button left
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }).frame(width: 50, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Kế hoạch mua sắm")
                        .appFont(style: .body,weight: .bold, size: 18, color: Color(hex: "#0049C3"))
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Text("")
                            .foregroundColor(.black)
                    }).frame(width: 50, alignment: .trailing)
                }
                
                Image("icon_item_5")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .offset(y: 40)
                    .zIndex(99)
                
                VStack(alignment: .center, spacing: 15) {
                    VStack(alignment: .center, spacing: 15) {
                        Text("Kế hoạch mua sắm tài sản lớn").appFont(style: .body,weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                        Text("Dự đoán nguồn lực tài chính để đạt được các mục tiêu mua sắm tài sản lớn.")
                            .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#808080"))
                    }
                    .padding(.top, 40)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack (alignment: .center) {
                            Image("ic_check_circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                            Text("Xác định giá trị tài sản có thể mua.")
                                .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#808080"))
                                .padding(.leading,10)
                        }
                        HStack (alignment: .center) {
                            Image("ic_check_circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                            Text("Nắm được lộ trình tài chính cần chuẩn bị.")
                                .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#808080"))
                                .padding(.leading,10)
                        }
                        HStack (alignment: .center) {
                            Image("ic_check_circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                            Text("Gợi ý phương án tối ưu hóa nhất.")
                                .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#808080"))
                                .padding(.leading,10)
                        }
                    }
                }
                .padding(.all, 15)
                .frame(width: UIScreen.screenWidth - 76)
                .background(Color.white)
                .cornerRadius(15)
                .myShadow()
                .offset(y: -20)

                NavigationLink {
                    ShoppingPlanStep1View()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Sử dụng ngay")
                        .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#ffffff"))
                }
                .buttonStyle(BlueButton())
            }
            .padding(.horizontal, 37)
            .offset(x: 0, y: 40)
        }
    }
}

struct ShoppingPlanView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingPlanView()
    }
}
