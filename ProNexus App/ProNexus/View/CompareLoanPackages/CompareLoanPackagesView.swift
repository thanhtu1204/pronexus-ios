//
//  CompareLoanPackagesView.swift
//  ProNexus
//
//  Created by TUYEN on 12/6/21.
//

import SwiftUI

struct CompareLoanPackagesView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    var pack1: [Pack1] = []
    var pack2: [Pack2] = []
    var pack3: [Pack3] = []
    
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
                    }).frame(width: 20, alignment: .leading)
                    
                    Spacer()
                    
                    Text("So sánh gói vay tiêu dùng")
                        .appFont(style: .body,weight: .bold, size: 18, color: Color(hex: "#0049C3"))
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Text("")
                            .foregroundColor(.black)
                    }).frame(width: 20, alignment: .trailing)
                }
                
                Image("icon_item_3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .offset(y: 40)
                    .zIndex(99)
                
                VStack(alignment: .center, spacing: 15) {
                    VStack(alignment: .center, spacing: 15) {
                        Text("So sánh gói vay tiêu dùng").appFont(style: .body,weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                        Text("Vay tiền là cam kết lớn. Xác định chính xác khoản thanh toán, tiền lãi và thời gian biểu.")
                            .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#808080"))
                    }
                    .padding(.top, 40)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack (alignment: .center) {
                            Image("ic_check_circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                            Text("So sánh dựa trên phương thức tính lãi khác nhau.")
                                .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#808080"))
                                .padding(.leading,10)
                        }
                        HStack (alignment: .center) {
                            Image("ic_check_circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                            Text("Tính toán lộ trình trả nợ chi tiết.")
                                .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#808080"))
                                .padding(.leading,10)
                        }
                        HStack (alignment: .center) {
                            Image("ic_check_circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                            Text("Gợi ý lựa chọn gói vay tối ưu.")
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
                    CompareLoanPackagesForm(pack1: pack1, pack2: pack2, pack3: pack3)
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

//struct CompareLoanPackagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompareLoanPackagesView(pack1: pack1, pack2: pack2, pack3: pack3)
//    }
//}
