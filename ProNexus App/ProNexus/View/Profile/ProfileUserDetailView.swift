//
//  ProfileDetailView.swift
//  ProNexus
//
//  Created by IMAC on 11/4/21.
//

import SwiftUI
import SwiftyUserDefaults
import SDWebImageSwiftUI

struct ProfileUserDetail: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var service: UserApiService
    
    let numberString = "1900 633 019"
    
    @State var isShowDropdown = false
    @ObservedObject var sessionSession = SessionStore()
    
    var body: some View {
        
        let iconChevronRight = Image("ic_chevron_right").resizable().aspectRatio(contentMode: .fill).frame(width: 6, height: 12)
        
        let iconArrowDown = Image("ic_arrow_down").resizable().aspectRatio(contentMode: .fill).frame(width: 8, height: 8)
        
        VStack () {
            VStack (){
                // header
                Header(title: "Hồ sơ cá nhân", contentView: {
//                            ButtonIcon(name: "arrow.left", onTapButton: {
//                                self.presentationMode.wrappedValue.dismiss()
//                            })
//                            Spacer()
                }).padding(.bottom, 30)
                //
                VStack() {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            VStack () {
                                WebImage(url: URL(string: Defaults.userPicture ?? ""))
                                    .resizable()
                                    .onSuccess { image, data, cacheType in
                                        // Success
                                        // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                    }
                                    .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                                    .placeholder {
                                        Image("ic_picture")
                                    }
                                    .indicator(.activity) // Activity Indicator
                                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                                    .myShadow()
                                
                                if let name = Defaults.userFullName {
                                    Text(name)
                                        .font(Font.custom("AvertaStdCY-Bold", size: 20))
                                        .offset(y: 10)
                                }
                            }
                            .padding(.bottom, 20)
                            
                            VStack() {
                                NavigationLink(destination: {
                                    VStack {
                                        if let user = Defaults.userLogger {
                                            if user.role == UserRole.advisor.rawValue {
                                                ProfileAdvisorFormEdit().environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                            } else {
                                                ProfileUserFormEdit(id: user.customerID ?? "").environmentObject(UserApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                            }
                                        }
                                    }
                                }) {
                                    HStack (alignment: .center, spacing: 20) {
                                        Image("ic_profile").resizable().aspectRatio(contentMode: .fit).frame(width: 16, height: 16)
                                        Text("Hồ sơ cá nhân").appFont(style: .title1, size: 15).padding(.vertical, 10)
                                        Spacer()
                                        iconChevronRight
                                    }
                                }
                                
                                Divider()
                                
                                Group () {
                                    HStack (alignment: .center, spacing: 20) {
                                        Image("ic_connect").resizable().aspectRatio(contentMode: .fit).frame(width: 16, height: 16)
                                        Text("Mời bạn bè").appFont(style: .title1, size: 15).padding(.vertical, 10)
                                        Spacer()
                                        iconChevronRight
                                    }.onTapGesture {
                                        actionSheet(url: "https://pronexus.com.vn/")
                                    }
                                    
                                    Divider()
                                    
                                    HStack (alignment: .center, spacing: 20) {
                                        Image("ic_setting").resizable().aspectRatio(contentMode: .fit).frame(width: 16, height: 16)
                                        Text("Cài đặt").appFont(style: .title1, size: 15).padding(.vertical, 10)
                                        Spacer()
                                        iconChevronRight
                                    }
                                }
                                
                                Divider()
                                
                                Button(action: {
                                    self.isShowDropdown.toggle()
                                }, label: {
                                    HStack (alignment: .center, spacing: 20) {
                                        
                                        Image("ic_support").resizable().aspectRatio(contentMode: .fit).frame(width: 16, height: 16)
                                        Text("Trung tâm hỗ trợ").appFont(style: .title1, size: 15).padding(.vertical, 10)
                                        Spacer()
                                        if isShowDropdown {
                                            iconArrowDown
                                        } else {
                                            iconChevronRight
                                        }
                                        
                                    }
                                })
                                
                                if $isShowDropdown.wrappedValue {
                                    Group () {
                                        VStack (alignment: .leading) {
                                            NavigationLink {
//                                                UserManualView()
//                                                    .navigationBarBackButtonHidden(true)
//                                                    .navigationBarHidden(true)
                                            } label: {
                                                HStack (alignment: .center, spacing: 20) {
                                                    Image("ic_blue_dot").resizable().aspectRatio(contentMode: .fit).frame(width: 6, height: 6)
                                                    Text("Về ProNexus").appFont(style: .title1, size: 15).padding(.vertical, 10)
                                                }
                                            }
                                            NavigationLink {
                                                UserManualView(places: Place.samples(), list2: AppointmentSchedule.lists(), list3: MarketPlace.lists3())
                                                    .navigationBarBackButtonHidden(true)
                                                    .navigationBarHidden(true)
                                            } label: {
                                                HStack (alignment: .center, spacing: 20) {
                                                    Image("ic_blue_dot").resizable().aspectRatio(contentMode: .fit).frame(width: 6, height: 6)
                                                    Text("Hướng dẫn sử dụng").appFont(style: .title1, size: 15).padding(.vertical, 10)
                                                }
                                            }
                                            NavigationLink {
                                                UserManualView(places: Place.samples(), list2: AppointmentSchedule.lists(), list3: MarketPlace.lists3())
                                                    .navigationBarBackButtonHidden(true)
                                                    .navigationBarHidden(true)
                                            } label: {
                                                HStack (alignment: .center, spacing: 20) {
                                                    Image("ic_blue_dot").resizable().aspectRatio(contentMode: .fit).frame(width: 6, height: 6)
                                                    Text("Câu hỏi thường gặp").appFont(style: .title1, size: 15).padding(.vertical, 10)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Button {
                                    UIApplication.shared.open(URL(string: "https://pronexus.com.vn/dieu-khoan-su-dung.html")!)
                                } label: {
                                    HStack (alignment: .center, spacing: 20) {
                                        Image("ic_policy").resizable().aspectRatio(contentMode: .fit).frame(width: 16, height: 16)
                                        Text("Điều quản và pháp lý").appFont(style: .title1, size: 15).padding(.vertical, 10)
                                        Spacer()
                                        iconChevronRight
                                    }
                                }

                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 20)
                            .frame(width: UIScreen.screenWidth - 74)
                            .background(Color.white)
                            .cornerRadius(15)
                        }
                        .frame(width: UIScreen.screenWidth - 74)
                        .padding(.horizontal, 2)
                        .myShadow()
                        
                        Spacer()
                        
                        Button(action: {
                            _ = self.sessionSession.signOut()
                            self.resetLocalStorage()
                            service.postLogout()
                            self.navigateLoginScreen()
                        }, label: {
                            HStack (alignment: .center, spacing: 15) {
                                Image("ic_logout").resizable().frame(width: 17, height: 17)
                                Text("Đăng xuất").appFont(style: .title1, size: 15, color: (Color(hex: "#4C99F8")))
                                    .padding(.vertical, 10)
                            }
                        })
                        .buttonStyle(BlueButtonBorder())
                        .padding(.top, 40)
                        .padding(.bottom, 15)
                        
                        HStack(alignment: .center, spacing: 15) {
                            Button(action: {
                                let telephone = "tel://"
                                let formattedString = telephone + numberString
                                guard let url = URL(string: formattedString) else { return }
                                UIApplication.shared.open(url)
                            }, label: {
                                Image("ic_act_phone").resizable().frame(width: 25, height: 25)
                            })
                            
                            Button(action: {
                                let email = "info@pronexus.com.vn"
                                if let url = URL(string: "mailto:\(email)") {
                                  if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url)
                                  } else {
                                    UIApplication.shared.openURL(url)
                                  }
                                }
                            }, label: {
                                Image("ic_act_email").resizable().frame(width: 25, height: 25)
                            })
                            
                            Button(action: {
                                if let url = URL(string: "https://www.pronexus.com.vn") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Image("ic_act_web").resizable().frame(width: 25, height: 25)
                            })
                            
                            Button(action: {
                                if let url = URL(string: "https://www.facebook.com/pronexus.com.vn") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Image("ic_act_fb").resizable().frame(width: 25, height: 25)
                            })
                        }
                        .padding(.bottom, 80)

                        
                    }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
                }
            }
        }
        .offset(x: 0, y: UIApplication.statusBarHeight)
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }

    func actionSheet(url: String) {
        guard let data = URL(string: url) else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func resetLocalStorage() -> Void {
        NotificationCenter.default.post(name: .didUserLogout,
                                        object: nil, userInfo: nil)
        Defaults.accessToken = nil
        Defaults.userLogger = nil
        Defaults.userName = ""
    }
    
    func navigateLoginScreen() -> Void {
        let vc = UIHostingController(rootView: Login().environmentObject(UserApiService()))
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
}

struct ProfileUserDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Setting))
            ProfileUserDetail().environmentObject(UserApiService())
        }
    }
}
