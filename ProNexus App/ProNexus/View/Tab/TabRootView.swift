//
//  TabRootView.swift
//  ProNexus
//
//  Created by thanh cto on 03/11/2021.
//

import SwiftUI
import SwiftyUserDefaults

extension Notification.Name {
    static let didUserLoginSuccess = Notification.Name("userLogged")
    static let didUserLogout = Notification.Name("userLogout")
    static let didAlertMessage = Notification.Name("alertView")
    static let didHiddenTabBar = Notification.Name("hiddenTabBar")
    static let didShowTabBar = Notification.Name("showTabBar")
    static let didRefreshSchedule = Notification.Name("refreshMySchedule")
}

struct TabRootView: View {
    
    @EnvironmentObject var baseData : TabViewSettingModel
    
    @EnvironmentObject var userService: UserApiService
    
    @State var isAuthentication = false
    
    @State var isAlertView = false
    
    @State var alertMessage = ""
    
    @State var showTabbar = false
    @State var showOnBoading = true
    
    @ObservedObject var sessionStore = SessionStore()
    
    // Hiding Tab Bar..
    init() {
        UITabBar.appearance().isHidden = true
        sessionStore.listen()
    }
    
    
    var body: some View {
        if Defaults.onBoarding == 0 {
            OnBoarding()
        } else
        {
            VStack {
                ZStack {
                    // Tab VIew...
                    NavigationView {
                        VStack(spacing: 0) {
                            if self.userService.isAuthentication {
                                TabView (selection: $baseData.currentTab) {
                                    //home
                                    HomeView().environmentObject(UserApiService()).environmentObject(ProviderApiService())
                                        .tag(TabEnum.Home)
                                    //chat
                                    ListRoom()
                                        .tag(TabEnum.Message)
                                    
                                    //profile detail
                                    ProfileUserDetail().environmentObject(UserApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                        .tag(TabEnum.Setting)
                                }
                                if showTabbar
                                {
                                    // Custom Tab Bar....
                                    //                        CustomTabBar(selectedTab: $baseData.currentTab).environmentObject(userService).transition(.fade)
                                }
                                CustomTabBar(selectedTab: $baseData.currentTab).environmentObject(userService).transition(.fade)
                            } else
                            {
                                Login().environmentObject(userService)
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                        .preferredColorScheme(.light)
                    }
                    
                    if userService.isShowModalCreateSchedule {
                        AdvisorCreateSchedulePopupView(show: $userService.isShowModalCreateSchedule).environmentObject(ProviderApiService())
                    }
                    
                    // show alert if have an error
                    if $isAlertView.wrappedValue {
                        
                        AlertView(msg: alertMessage, show: $isAlertView).zIndex(9999999)
                    }
                    
                    
                }
            }.onAppear(perform: {
                checkLoginValidity() // mới mở app lên
            }).onReceive(NotificationCenter.default.publisher(for: .didUserLoginSuccess)) { (output) in
                setLogin()
            }.onReceive(NotificationCenter.default.publisher(for: .didUserLogout)) { (output) in
                setLogout()
            }.onReceive(NotificationCenter.default.publisher(for: .didAlertMessage)) { (output) in
                if let data = output.userInfo as NSDictionary?
                {
                    if let msg = data["msg"] as? String
                    {
                        alertMessage = data["msg"] as! String
                        isAlertView = true
                    }
                    
                }
            }.onReceive(NotificationCenter.default.publisher(for: .didHiddenTabBar)) { (output) in
                self.showTabbar = false
            }.onReceive(NotificationCenter.default.publisher(for: .didShowTabBar)) { (output) in
                withAnimation {
                    self.showTabbar = true
                }
            }
        }
    }
    
    func checkLoginValidity() {
        self.userService.isAuthentication = Defaults.accessToken != nil
        //        self.baseData.isLogin = Defaults.accessToken != nil
        //        self.isAuthentication = Defaults.accessToken != nil
    }
    
    func setLogout() {
        self.userService.isAuthentication = false
        //        self.baseData.isLogin = false
        //        self.isAuthentication = false
    }
    
    func setLogin() {
        self.userService.isAuthentication = true
        //        self.baseData.isLogin = true
        //        self.isAuthentication = true
    }
}

struct TabRootView_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}
