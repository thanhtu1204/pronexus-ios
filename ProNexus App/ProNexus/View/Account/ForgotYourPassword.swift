//
//  ForgotYourPassword.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import SwiftUI

struct ForgotYourPassword: View {
    
    @State var isShowAlertError = false
    @State var message = ""
    
    @EnvironmentObject var service : UserApiService
    @State var isValidForm = false
    
    @State var phone: String = ""
    
    var body: some View {
        VStack {
            ZStack  {
                Image("bg_login_regsiter").resizable().scaledToFill().edgesIgnoringSafeArea(.all)
                VStack (alignment: .center, spacing: 20) {
                    
                    Image("logo").resizable().scaledToFit().frame(width: 98, height: 78)
                    
                    Text("QUÊN MẬT KHẨU")
                        .appFont(style: .body, size: 16, color: Color(hex: "#333"))
                    
                    VStack(alignment: .leading, spacing: 0, content: {
                        
                        Group {
                            VStack(spacing: 8, content: {
                                MyTextField(label: "Số điện thoại", type: .phone, value: $phone.onUpdate(checkFormValid), required: true)
                            })
                        }
                        
                    }).padding(.top,25)
                                        
                    
                    VStack {
                        if $isValidForm.wrappedValue {
                            NavigationLink {
                                VerificationOtp(phone: phone).environmentObject(service).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                            } label: {
                                Text("Gửi").appFont(style: .body, color: .white)
                            }.buttonStyle(GradientButtonStyle())
                            
                        } else
                        {
                            Button(action: {
                               
                            }, label: {
                                Text("Gửi").appFont(style: .body, color: .white)
                            }).buttonStyle(RoundedSilverButtonStyle())
                        }
                    }.padding(.vertical, 20)

                                       
                    
                    HStack {
                        
                        Text("Bạn chưa có tài khoản?")
                            .appFont(style: .body, color: Color(hex: "#707070"))
                        
                        Button(action: {
                            service.isShowRegisterModalType = true
                        }, label: {
                            Text("Đăng ký")
                                .appFont(style: .body, color: Color(hex: "#0974DF"))
                        })
                        
                    }.padding(0)
                    
                    Spacer()
                    
                }.padding(.horizontal, 37)
                    .padding(.top, 30)
                                
                // show popup register type
                if $service.isShowRegisterModalType.wrappedValue {
                    ChooseAccountTypeModal(show: $service.isShowRegisterModalType)
                }
                
                // show alert if have an error
                if $isShowAlertError.wrappedValue {
                    
                    AlertView(msg: message, show: $isShowAlertError)
                }
                
            }.padding(.all, 0)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    service.isCreateNewOtpResetPass = true
                }
        }
        
    }
    
    func checkFormValid() {
        self.isValidForm = !self.phone.isBlank
        && self.phone.isValidPhone()
        && (self.phone.count == 10)
    }
}

struct ForgotYourPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotYourPassword().environmentObject(UserApiService())
    }
}
