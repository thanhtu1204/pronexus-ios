//
//  PaymentMethodView.swift
//  ProNexus
//
//  Created by Tú Dev app on 07/11/2021.
//

import SwiftUI

struct PaymentMethodView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var checkedMomo = true
    @State var checkedAtm = true
    @State var checkedCreditCard = true


    var body: some View {
        ScrollView(.vertical) {
            VStack {
                // HEADER
                ZStack(alignment: .center) {
                    HStack(spacing: 0) {
                        //button left
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }).frame(width: 50, alignment: .center)
                        
                        Spacer()
                        
                        
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Text("Phương thức thanh toán")
                            .appFont(style: .body,weight: .bold, size: 20, color: Color(.white))
                        
                    }
                }.background(
                    Image("bg_header")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth, height: 180)
                        .edgesIgnoringSafeArea(.top)
                )
            }
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 15){
                    Text("Chọn Phương thức Thanh toán").appFont(style: .body, weight: .bold, size: 15, color: Color(hex:"#4D4D4D")).padding(.top,22)
                    
                    HStack{
                        Toggle(isOn: $checkedMomo) {
                            
                        }.padding(.all, 0)
                            .toggleStyle(CheckboxCirlceLeftStyle())
                        Image("ic_momo").resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 38)
                            
                        Text("Ví MoMo").appFont(style: .body, size: 12, color: Color(hex:"#808080"))
                    }.padding(.top,19)
                    Divider()
                    HStack{
                        Toggle(isOn: $checkedAtm) {
                            
                        }.padding(.all, 0)
                            .toggleStyle(CheckboxCirlceLeftStyle())
                        Image(systemName: "creditcard.fill").resizable()
                            .scaledToFit()
                            .frame(width: 33, height:21 ).padding(.leading,6)
                            
                        Text("Thẻ ATM Hỗ trợ Internet Banking").appFont(style: .body, size: 12, color: Color(hex:"#808080")).padding(.leading,20)
                    }.padding(.top,19)
                    Divider()
                    HStack{
                        Toggle(isOn: $checkedCreditCard) {
                            
                        }.padding(.all, 0)
                            .toggleStyle(CheckboxCirlceLeftStyle())
                        Image(systemName: "creditcard.and.123").resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 22).padding(.leading,6)
                            
                        VStack{
                            Text("Thẻ Tín dụng/Ghi nợ").appFont(style: .body, size: 12, color: Color(hex:"#808080"))
                            HStack{
                                Image( "ic_masterCard").resizable()
                                    .scaledToFit()
                                    .frame(width: 26, height: 26).padding(.leading,6)
                                Image("ic_visaCard").resizable()
                                    .scaledToFit()
                                    .frame(width: 34, height: 22).padding(.leading,6)
                                Image("ic_jcb").resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 26).padding(.leading,6)
                            }
                        }.padding(.leading,20).padding(.bottom,20)
                    }.padding(.top,19)

                    
                  
                }
                .padding(.horizontal, 33)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .offset(x: 0, y: 30)
                
                VStack(alignment: .leading, spacing: 15){
                    HStack{
                        Text("Tổng thanh toán").appFont(style: .body,weight: .bold, size: 14, color: Color(hex:"#4D4D4D")).padding(20)
                        Spacer()
                        Text("550.000đ")
                            .appFont(style: .body, size: 12, color: Color(hex: "#50A0FC")).padding(20)
                    }
                    
                }
                .padding(.horizontal, 33)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .offset(x: 0, y: 30)
                Spacer()
                HStack(alignment: .center){
                    Button(action: {}, label: {
                        Text("Đăng nhập").appFont(style: .body, color: .white)
                    })
                        .buttonStyle(GradientButtonStyle())

                }.offset(x:120,y:30)
            }.offset(y: 30)
                .padding([.bottom, .horizontal], 30)
        }
        
    }
}


struct PaymentMethod_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodView()
    }
}
