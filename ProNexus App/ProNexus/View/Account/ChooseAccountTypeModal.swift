//
//  ChooseAccountTypeModal.swift
//  ProNexus
//
//  Created by thanh cto on 21/11/2021.
//

import SwiftUI

struct ChooseAccountTypeModal: View {
    @Binding var show: Bool
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                
                ZStack {
                    Text("Đăng ký")
                        .appFont(style: .body, weight: .bold, color: Color(hex: "#4D4D4D"))
                    Button {
                        show.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill").resizable().frame(width: 18, height: 18).foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 0)
                    }
                    
                }
                Divider()
                
                Text("Xin hãy chọn danh mục bạn muốn đăng ký tài khoản")
                    .appFont(style: .body, color: Color(hex: "#4D4D4D"))
                
                Spacer()
                Divider()
                HStack {
                    //
                    
                    NavigationLink {
                        RegisterAdvisorView()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                        
//                        SubmitForm2View()
//                            .environmentObject(UserApiService())
//                            .navigationBarBackButtonHidden(true)
//                            .navigationBarHidden(true)
                    } label: {
                        Text("Cố vấn tài chính").appFont(style: .body, color: .white)
                    }.buttonStyle(GradientButtonStyle())
                    
                    NavigationLink {
                        RegisterCustomer()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    } label: {
                        Text("Khách hàng cá nhân").appFont(style: .body, color: .white)
                    }.buttonStyle(GradientButtonStyle())
                    
                    
                }
            }
            .padding()
            .frame(width: 350, height: 190)
            .background(Color.white)
            .cornerRadius(15)
            .myShadow()
        }
        .padding(.all, 0)
        .frame(width: screenWidth(), height: screenHeight())
        .background(Color.black.opacity(0.5)).edgesIgnoringSafeArea(.all)
    }
}

struct ChooseAccountTypeModal_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAccountTypeModal(show: .constant(true))
    }
}
