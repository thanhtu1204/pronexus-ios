//
//  RegisterAdvisorView.swift
//  ProNexus
//
//  Created by Tú Dev app on 06/11/2021.
//

import SwiftUI

struct RegisterAdvisorView: View {
    
    @State var isShowAlertError = false
    @State var message = ""
    
    @EnvironmentObject var service : UserApiService
    @Environment(\.presentationMode) private var presentationMode
    @State var isValidForm = false
    @State var showsDatePicker = false
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .topLeading) {
                Image("bg_login_regsiter").resizable().scaledToFill().offset(x: 0, y: -5).edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0) {
                        Group {
                            Image("logo").resizable().scaledToFit().frame(width: 98, height: 78)
                            
                            Text("ĐĂNG KÝ ADVISOR")
                                .appFont(style: .body, size: 18, color: Color(hex: "#333")).padding(.top,12)
                            
                            Spacer().padding(.vertical, 10)
                            
                            Group {
                                HStack(spacing: 8, content: {
                                    MyTextField(label: "Họ Đệm", value: $service.dataRegisterAdvisor.firstname.onUpdate(checkFormValid), required: true)
                                    MyTextField(label: "Tên", value: $service.dataRegisterAdvisor.lastname.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyTextField(label: "Số điện thoại", type: .phone, value: $service.dataRegisterAdvisor.userName.onUpdate(checkFormValid), required: true).onTapGesture {
                                        self.showsDatePicker.toggle()
                                    }
                                })
                            }
                            
                            Group {
                                HStack(spacing: 8, content: {
                                    
                                    VStack (alignment: .leading) {
                                        MyTextField(label: "Ngày sinh", value: $service.dataRegisterAdvisor.dob.onUpdate(checkFormValid), required: true, readOnly: true)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        self.showsDatePicker.toggle()
                                    }
                                    
                                    Group {
                                        DropdownSelector(
                                            label: "Giới tính",
                                            required: true,
                                            options: [
                                                DropdownOption(key: UUID().uuidString, value: "Nam"),
                                                DropdownOption(key: UUID().uuidString, value: "Nữ")
                                            ],
                                            onOptionSelected: { option in
                                                service.dataRegisterAdvisor.gender = option.value
                                            }).zIndex(999)
                                    }
                                })
                            }
                            
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyTextField(label: "Địa chỉ email", type: .email, value: $service.dataRegisterAdvisor.userEmail.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyPasswordField(label: "Mật khẩu", value: $service.dataRegisterAdvisor.password.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyTextField(label: "Mã người giới thiệu", value: $service.dataRegisterAdvisor.referCode)
                                })
                            }
                            
                            HStack(alignment: .center, spacing: 15){
                                
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Quay lại").appFont(style: .body, color: .white)
                                })
                                    .buttonStyle(RoundedSilverButtonStyle())
                                
                                
                                //                            Button(action: requestRegister, label: {
                                //                                Text("Tiếp theo").appFont(style: .body, color: .white)
                                //                            })
                                //
                                //                                .buttonStyle(GradientButtonStyle())
                                
                                if $isValidForm.wrappedValue {
                                    NavigationLink {
                                        SubmitForm1View()
                                            .navigationBarBackButtonHidden(true)
                                            .navigationBarHidden(true)
                                    } label: {
                                        Text("Tiếp theo").appFont(style: .body, color: .white)
                                    }.buttonStyle(GradientButtonStyle())
                                } else
                                {
                                    Button(action: {
                                        
                                    }, label: {
                                        Text("Tiếp theo").appFont(style: .body, color: .white)
                                    }).buttonStyle(RoundedSilverButtonStyle())
                                }
                                
                            }
                            .frame(width: screenWidth() - 74)
                            .padding(.horizontal, 37)
                            .padding(.top,10)
                            .padding(.bottom, 100)
                            
                        }
                    }
                    .frame(width: UIScreen.screenWidth - 74)
                    .padding(.horizontal, 37)
                    .padding(.vertical, 40)
                    //                    .adaptsToKeyboard()
                }
                
                if $showsDatePicker.wrappedValue {
                    MyDatePicker(show: $showsDatePicker, dateString: $service.dataRegisterAdvisor.dob)
                }
                
            }.navigationBarHidden(true)
        }
    }
    
    func checkFormValid() {
        self.isValidForm = !self.service.dataRegisterAdvisor.firstname.isBlank
        && !self.service.dataRegisterAdvisor.lastname.isBlank
        && self.service.dataRegisterAdvisor.userName.isValidPhone()
        && (self.service.dataRegisterAdvisor.userName.count == 10)
        && !self.service.dataRegisterAdvisor.dob.isBlank
        && !self.service.dataRegisterAdvisor.gender.isBlank
        && self.service.dataRegisterAdvisor.userEmail.isEmail()
        && !self.service.dataRegisterAdvisor.password.isBlank
    }
}


struct RegisterAdvisorView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterAdvisorView().environmentObject(UserApiService())
    }
}
