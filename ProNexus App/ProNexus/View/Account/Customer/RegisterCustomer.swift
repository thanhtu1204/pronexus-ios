//
//  RegisterCustomer.swift
//  ProNexus
//
//  Created by thanh cto on 06/11/2021.
//

import SwiftUI

struct RegisterCustomer: View {
    
    @ObservedObject var viewModel = ViewModel()
    @State private var checked = false
    @State var isShowAlertError = false
    @State var message = ""
    
    @EnvironmentObject var service : UserApiService
    @Environment(\.presentationMode) var presentationMode
    @State var isValidForm = false
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            ZStack (alignment: .topLeading) {
                Image("bg_login_regsiter").resizable().scaledToFill().edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack (alignment: .center, spacing: 0) {
                        
                        Image("logo").resizable().scaledToFit().frame(width: 98, height: 78)
                        
                        Text("ĐĂNG KÝ")
                            .appFont(style: .body, size: 16, color: Color(hex: "#333")).padding(.vertical, 10)
                        
                        
                        // FORM
                        Group {
                            Group {
                                HStack(spacing: 8, content: {
                                    MyTextField(label: "Họ Đệm", value: $service.dataRegister.firstname, required: true)
                                    MyTextField(label: "Tên", value: $service.dataRegister.lastname.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyTextField(label: "Số điện thoại", type: .phone, value: $service.dataRegister.phone.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyTextField(label: "Địa chỉ email", type: .email, value: $service.dataRegister.userEmail.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyPasswordField(label: "Mật khẩu", value: $service.dataRegister.password.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyTextField(label: "Mã người giới thiệu", value: $service.dataRegister.referCode)
                                })
                            }
                        }
                        
                        
                        
                        HStack (alignment: .center, spacing: 4) {
                            Toggle(isOn: $checked.onUpdate(checkFormValid)) {
                                
                            }.padding(.all, 0).padding(.trailing, 4)
                                .toggleStyle(CheckboxSquareStyle())
                            
                            Text("Tôi đã đọc và đồng ý với các")
                                .appFont(style: .body, size: 10, color: Color(hex: "#707070"))
                            Spacer()
                            Button(action: {
                                showingSheet.toggle()
                            }, label: {
                                Text("điều khoản sử dụng của Pronexus")
                                    .appFont(style: .body, size: 10, color: Color(hex: "#0974DF"))
                            }).sheet(isPresented: $showingSheet) {
                                
                                VStack {
                                    ZStack {
                                        Text("ĐIỀU KHOẢN PHÁP LÝ")
                                            .appFont(style: .body, weight: .bold, size: 16, color: Color(hex: "#4D4D4D")).padding(.vertical, 30).frame(maxWidth: .infinity, alignment: .center)
                                        Button {
                                            showingSheet.toggle()
                                        } label: {
                                            Image(systemName: "xmark.circle.fill").resizable().frame(width: 18, height: 18).foregroundColor(.gray)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                .padding(.trailing, 0)
                                        }
                                        
                                    }
                                    MyWebView(urlAddress: "https://pronexus.com.vn/dieu-khoan-su-dung.html")
                                }.padding(.horizontal, 30)
                            }
                            
                            
                        }.padding(0)
                        
                        
                        //                    VStack {
                        //                        if $isValidForm.wrappedValue {
                        //                            Button(action: requestRegister, label: {
                        //                                Text("Đăng Ký").appFont(style: .body, color: .white)
                        //                            })
                        //                                .buttonStyle(GradientButtonStyle())
                        //                        } else
                        //                        {
                        //                            Button(action: {
                        //
                        //                            }, label: {
                        //                                Text("Đăng Ký").appFont(style: .body, color: .white)
                        //                            }).buttonStyle(RoundedSilverButtonStyle())
                        //                        }
                        //                    }.padding(.vertical, 20)
                        
                        
                        HStack(alignment: .center, spacing: 15){
                            
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Quay lại").appFont(style: .body, color: .white)
                            })
                                .buttonStyle(RoundedSilverButtonStyle())
                            
                            if $isValidForm.wrappedValue {
                                Button(action: requestRegister, label: {
                                    Text("Đăng Ký").appFont(style: .body, color: .white)
                                })
                                    .buttonStyle(GradientButtonStyle())
                            } else
                            {
                                Button(action: {
                                    
                                }, label: {
                                    Text("Đăng Ký").appFont(style: .body, color: .white)
                                }).buttonStyle(RoundedSilverButtonStyle())
                            }
                            
                        }
//                        .frame(width: containerWidth())
//                        .padding(.horizontal, 37)
                        .padding(.vertical, 20)

                        HStack {
                            
                            Text("Bạn đã có tài khoản?")
                                .appFont(style: .body, color: Color(hex: "#707070"))
                            
                            Button(action: {
                                //                            self.presentationMode.wrappedValue.dismiss()
                                service.isShowRegisterModalType = false
                                Login().environmentObject(service)
                            }, label: {
                                Text("Đăng nhập")
                                    .appFont(style: .body, color: Color(hex: "#0974DF"))
                            })
                            
                            
                        }.padding(0)
                        
                        Spacer()
                        
                    }.padding(.horizontal, 37)
                        .padding(.top, 30)
                }
                
                // show screen confirm otp
                if $service.isShowModalConfirmCode.wrappedValue {
                    VerificationOtp(phone: service.dataRegister.phone).environmentObject(service).transition(.move(edge: .bottom))
                        .zIndex(1)
                }
                // show alert if have an error
                if $isShowAlertError.wrappedValue {
                    
                    AlertView(msg: message, show: $isShowAlertError)
                }
                
                
            }.padding(0)
        }
    }
    
    func checkFormValid() {
            self.isValidForm = !self.service.dataRegister.firstname.isBlank
            && !self.service.dataRegister.lastname.isBlank
            && self.service.dataRegister.phone.isValidPhone()
            && (self.service.dataRegister.phone.count == 10)
            && self.service.dataRegister.userEmail.isEmail()
            && !self.service.dataRegister.password.isBlank
            && checked
        }
    
    func requestRegister() {
        let data: [String: Any] = [
            "firstname": service.dataRegister.firstname,
            "lastname": service.dataRegister.lastname,
            "phone": service.dataRegister.phone,
            "username": service.dataRegister.phone,
            "password": service.dataRegister.password,
            "referCode": service.dataRegister.referCode,
            "userEmail": service.dataRegister.userEmail,
        ]
        service.postRegisterCustomer(parameters: data).done { response in
            if response.message == "The request is invalid." {
                if let modal = response.modalState{
                    if ((modal.name?.isEmpty) != nil) {
                        self.message = "Số điện thoại đã tồn tại"
                    } else if ((modal.email?.isEmpty) != nil) {
                        self.message = "Email đã tồn tại"
                    } else if ((modal.passwords?.isEmpty) != nil) {
                        self.message = "Mật khẩu không nhỏ hơn 6 ký tự"
                    }
                }
                self.isShowAlertError = true
            } else {
                self.service.isShowModalConfirmCode = true
                // show modal confirm
            }
        }
    }
    
    
}

struct RegisterCustomer_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCustomer().environmentObject(UserApiService())
    }
}
