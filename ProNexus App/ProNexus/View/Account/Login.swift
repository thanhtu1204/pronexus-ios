//
//  Login.swift
//  ProNexus
//
//  Created by IMAC on 11/4/21.
//


import SwiftUI
import SwiftyUserDefaults
import FieldValidatorLibrary
import Firebase
import Networking
import PromiseKit

//import PromiseKit

struct Login: View {
    
    @State var phone = ""
    @State var password = ""
    
    @State var checked = true
    
    @State var isShowAlertError = false
    @State var message = ""
    @State var isValidForm = false
    
    @ObservedObject var sessionSession = SessionStore()
    
    @EnvironmentObject var service : UserApiService
    
    @StateObject var usernameValid = FieldChecker2<String>() // validation state of username field
    @StateObject var passwordValid = FieldChecker2<String>() // validation state of password field
    @Environment(\.isPreview) var isPreview
    
    @State var loading =  false
    
    
    var body: some View {
        NavigationView {
                ZStack  {
                    
                    Image("bg_login_regsiter").resizable().scaledToFill().edgesIgnoringSafeArea(.all)
                    
                    VStack (alignment: .center, spacing: 0) {
                        
                        Image("logo").resizable().scaledToFit().frame(width: 98, height: 78)
                    
                        Text("ĐĂNG NHẬP")
                            .appFont(style: .body, size: 16, color: Color(hex: "#333"))
                            .padding(.vertical, 20)
                        
                        VStack(alignment: .leading, spacing: 0, content: {
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyTextField(label: "Số điện thoại", type: .phone, value: $phone.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                            
                            
                            Group {
                                VStack(spacing: 8, content: {
                                    MyPasswordField(label: "Mật khẩu", value: $password.onUpdate(checkFormValid), required: true)
                                })
                            }
                            
                        }) .padding(.top,25)
                        
                        
                        HStack {
                            Toggle(isOn: $checked) {
                                
                            }.padding(.all, 0)
                                .toggleStyle(CheckboxSquareStyle())
                            Text("Lưu mật khẩu")
                                .appFont(style: .body, size: 12, color: Color(hex: "#707070"))
                            Spacer()
                            
                            
                            NavigationLink {
                                ForgotYourPassword().environmentObject(UserApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
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
                        
                        VStack {
                            if $isValidForm.wrappedValue {
                                Button(action: requestLogin, label: {
                                    Text("Đăng nhập").appFont(style: .body, color: .white)
                                })
                                    .buttonStyle(GradientButtonStyle())
                            } else
                            {
                                Button(action: {
                                    
                                }, label: {
                                    Text("Đăng nhập").appFont(style: .body, color: .white)
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
                        .padding(.top, 60)
                    
                    if $service.isShowRegisterModalType.wrappedValue {
                        ChooseAccountTypeModal(show: $service.isShowRegisterModalType)
                    }
                    
                    // show alert if have an error
                    if $isShowAlertError.wrappedValue {
                        
                        AlertView(msg: message, show: $isShowAlertError)
                    }
                    
                    if $loading.wrappedValue {
                        SectionLoader()
                    }
                    
                }.padding(.all, 0)
                .onAppear(){
                if isPreview {
                    self.phone = "0931115280"
                    self.password = "123456a@"
                }
            }
        
        }
        
    }
    
    func checkFormValid() {
        self.isValidForm = !self.phone.isBlank
        && (self.phone.count == 10)
        && self.phone.isValidPhone()
        && !self.password.isBlank
    }
    
    
    func showAlert(text: String) {
        self.isShowAlertError = true
        self.message = text
    }
    
    
    func requestLogin() {
        
        let data: [String: Any] = [
            "username": self.phone,
            "password": self.password,
            "grant_type": "password"
        ]
        
        self.loading = true
        
        _ = service.postLogin(parameters: data).done { user in
            if user.error.isEmptyOrNil {
                
                //LOGIN FIREBASE
                
//                sessionSession.signIn(email: user.userEmail!, password: self.password)
//                sessionSession.signIn(email: "thanhdevapp@gmail.com", password: "123456")
                requestRegisterFirebase(user: user)
                
                self.loading = false
                
                if let token = Messaging.messaging().fcmToken {
                    print("FCM token after login: \(token)")
                    saveTokenFirebase(token: token, authToken: user.accessToken ?? "")
                }
                
                if let role = user.role {
                    if role == UserRole.advisor.rawValue {
                        Messaging.messaging().unsubscribe(fromTopic: "app_customer")
                        Messaging.messaging().subscribe(toTopic: "app_advisor")
                    } else
                    {
                        Messaging.messaging().unsubscribe(fromTopic: "app_advisor")
                        Messaging.messaging().subscribe(toTopic: "app_customer")
                    }
                }
                
                NotificationCenter.default.post(name: .didUserLoginSuccess,
                                                object: nil, userInfo: nil)
                service.isAuthentication = true
                let vc = UIHostingController(rootView: TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home)))
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            } else {
                
                self.loading = false
                showAlert(text: "\(user.errorMessage ?? "")")
            }
        }
    }
    
    func requestRegisterFirebase(user: UserProfileModel) {
        var phone = ( user.userName ?? "")
        let userEmail = "\(phone)@email.com"
        let password = "\(phone)@pronexus"
        
        phone = phone.replacingCharacters(in: ...phone.startIndex, with: "+84")
        
        //bỏ logic này đi vì khi user đổi email sẽ bị đăng ký lại user firebase
//        if !user.userEmail.isEmptyOrNil {
//            userEmail = user.userEmail!
//        }
        let data: [String: Any] = [
            "FullName": user.firstName! + " " + user.lastName!,
            "username": phone,
            "password": password,
            "userEmail": userEmail,
        ]
        

        _ = service.postLoginFirebase(parameters: data).done { response in
            sessionSession.signIn(email: userEmail, password: password)
        }.catch({_ in
            sessionSession.signIn(email: userEmail, password: password)
        })
    }
    
    
    func saveTokenFirebase(token: String, authToken: String)  -> Promise<CommonResponseModel> {
        let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
        networking.setAuthorizationHeader(token: authToken)
        let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error save token firebase"])
        let parameters: [String: Any] = [
            "GUID": token
        ]
        return Promise { seal in
            networking.post("\(ApiRouter.DEVICE_TOKEN)", parameterType: .json, parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                            seal.fulfill(rs)
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([AllDeviceNames.iPhone11.rawValue], id: \.self) { devicesName in
            Login().environmentObject(UserApiService())
                .previewDevice(PreviewDevice(rawValue: devicesName))
                .previewDisplayName(devicesName)
        }
        
    }
}

