//
//  CreateNewPass.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import SwiftUI
import FieldValidatorLibrary

struct CreateNewPass: View {
    
    
    @State var checked = true
    
    @State var isShowAlertError = false
    @State var message = ""
    
    @EnvironmentObject var service : UserApiService
    
    
    var body: some View {
        VStack {
            ZStack  {
                Image("bg_login_regsiter").resizable().scaledToFill().edgesIgnoringSafeArea(.all)
                VStack (alignment: .center, spacing: 20) {
                    
                    Image("logo").resizable().scaledToFit().frame(width: 98, height: 78)
                    
                    Text("ĐẶT LẠI MẬT KHẨU")
                        .appFont(style: .body, size: 16, color: Color(hex: "#333"))
                    
                    VStack {
                        MyPasswordField(label: "Mật khẩu", value: $service.dataResetPass.password)
                        MyPasswordField(label: "Nhập lại mật khẩu", value: $service.dataResetPass.confirmPass)
                    }
                    
                    
                    HStack {
                        Spacer()
                        NavigationLink {
                            ForgotYourPassword().environmentObject(UserApiService())
                        } label: {
                            Text("Quên mật khẩu?")
                                .appFont(style: .body, size: 12, color: Color(hex: "#50A0FC"))
                            //                            Button(action: {
                            //
                            //                            }, label: {
                            //                                Text("Quên mật khẩu?")
                            //                                    .appFont(style: .body, size: 12, color: Color(hex: "#50A0FC"))
                            //                            }).frame(maxWidth: .infinity, alignment: .trailing)
                            //                                .padding(.top,10)
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top,10)
                        
                        
                    }
                    
                    Button(action: requestCreateNewPass, label: {
                        Text("Đổi mật khẩu").appFont(style: .body, color: .white)
                    })
                        .buttonStyle(GradientButtonStyle())
                    
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
                
                if $service.isShowRegisterModalType.wrappedValue {
                    ChooseAccountTypeModal(show: $service.isShowRegisterModalType)
                }
                
                // show alert if have an error
                if $isShowAlertError.wrappedValue {
                    
                    AlertView(msg: message, show: $isShowAlertError)
                }
                
            }.padding(.all, 0)
        }
        
    }
    
    
    func requestCreateNewPass() {
        let data: [String: Any] = [
            "username": service.dataResetPass.phone,
            "password": service.dataResetPass.password,
            "code": service.dataResetPass.code
        ]
        
        _ = service.postResetPassByPhone(parameters: data).done { response in            
            if response == 200 {
                service.isAuthentication = true
                let vc = UIHostingController(rootView: TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home)))
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            } else {
                self.message = "Xảy ra lỗi không thể thay đổi mật khẩu"
                self.isShowAlertError = true
            }
        }
    }
    
}

struct CreateNewPass_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPass().environmentObject(UserApiService())
    }
}
