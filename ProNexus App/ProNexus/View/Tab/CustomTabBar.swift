//
//  CustomTabBar.swift
//  ProNexus
//
//  Created by thanh cto on 03/11/2021.
//

import SwiftUI
import SwiftyUserDefaults

struct CustomTabBar: View {
    
    @EnvironmentObject var userService: UserApiService
    
    @Binding var selectedTab: TabEnum
    
    @State var navToCalendar = false
    
    // Animation Namespace for sliding effect...
    @Namespace var animation
    
    var body: some View {
        
        HStack(spacing: 30){
            
            // Tab Bar Button....
            TabBarButton(image: "tab_item_home_normal", selectedTab: $selectedTab, tab: TabEnum.Home)
                       
            TabBarButton(image: "tabitem_cl_normal", selectedTab: $selectedTab.onUpdate {
                self.navToCalendar = true
            }, tab: TabEnum.Calendar)
            
            NavigationLink(destination: ListAppointmentView().environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true), isActive: $navToCalendar ) {
                EmptyView()
            }
            
            
            if let user = Defaults.userLogger
            {
                if user.role == UserRole.advisor.rawValue {
                    //advisor
                    Button(action: {
                        userService.isShowModalCreateSchedule = true
                        
                    }, label: {
                        
                        VStack(spacing: 8){
                            Image("tabitem_center")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 37, height: 42)
                        }
                        .frame(maxWidth: .infinity)
                    })
                } else {
                    // user
//                    TabBarButtonCenter(image: "tabitem_center", selectedTab: $selectedTab, tab: TabEnum.Advisor)
                    
                    NavigationLink {
                        SearchAdvisorView().environmentObject(ProviderApiService())
                            .environmentObject(ClassificationApiService())
                            .navigationBarHidden(true)
                    } label: {
                        VStack(spacing: 8){
                            Image("tabitem_center")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 37, height: 42)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            
            TabBarButton(image: "tabitem_chat",selectedTab: $selectedTab , tab: TabEnum.Message)
            
            TabBarButton(image: "tabitem_setting",selectedTab: $selectedTab, tab: TabEnum.Setting)
            
        }
        .padding(.top)
        .padding(.horizontal, 20)
        // decreasing the extra padding added...
        .padding(.vertical,-10)
        .padding(.bottom,getSafeArea().bottom == 0 ? 15 : getSafeArea().bottom)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: -4)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}

// extending view to get safe area...
extension View{
    func getSafeArea()->UIEdgeInsets{
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

struct TabBarButton: View {
    
//    var animation: Namespace.ID
    var image: String
    @Binding var selectedTab: TabEnum
    @State var tab: TabEnum
    
    var body: some View{
        
        Button(action: {
            withAnimation(.spring()){
                selectedTab = tab
            }
        }, label: {
            
            VStack(spacing: 8){
                
                Image(image)
                    .resizable()
                    // Since its asset image....
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundColor(selectedTab == tab ? Color(hex: "#50A0FC") : Color(hex: "#B3B3B3"))
//
                if selectedTab == tab{
                    Circle()
                        .fill(Color(hex: "#50A0FC"))
                        // Sliding Effect...
//                        .matchedGeometryEffect(id: "TAB", in: animation)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(maxWidth: .infinity)
        })
    }
}

struct TabBarButtonCenter: View {
    
//    var animation: Namespace.ID
    var image: String
    @Binding var selectedTab: TabEnum
    @State var tab: TabEnum
    
    var body: some View{
        
        Button(action: {
            withAnimation(.spring()){
                selectedTab = tab
            }
            
        }, label: {
            
            VStack(spacing: 8){                
                Image("tabitem_center")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 37, height: 42)
            }
            .frame(maxWidth: .infinity)
        })
    }
}


