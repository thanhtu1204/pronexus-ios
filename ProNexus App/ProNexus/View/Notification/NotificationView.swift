//
//  NotificationView.swift
//  ProNexus
//
//  Created by IMAC on 10/31/21.
//

import Foundation
import SwiftUI


//var tabsItems = [
//
//    Tab(tab: "Bài viết mới"),
//    Tab(tab: "Cố vấn viết"),
//    Tab(tab: "Cố vấn viết"),
//    Tab(tab: "Cố vấn viết"),
//]
//

struct TabNotifications: Identifiable {
    var id = UUID().uuidString
    var tab : String
}


struct NotificationView: View {
    
    @State var type: String?
    @State var selectedTab = scroll_Tabs[0]
    @State var show = false
    @State var selectedBag : BagModel!
    @State var loading = true
    @State var results: [NotificationItem] = []
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var service: UserApiService
    
    var body: some View {
        VStack{
            HStack (alignment: .center) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color(hex: Theme.buttonColor.primary.rawValue))
                    }
                    .padding(.all, 8.0)
                    .frame(width: 40, height: 40)
                    .background(Color("button"))
                    .cornerRadius(8)
                    .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
                }
                Spacer()
                Text("Thông báo").bold(size: 20)
                Spacer()
                Button(action: {}) {
                    HStack {
                        Image("ic_more")
                    }
                    .padding(.all, 8.0)
                    .frame(width: 40, height: 40)
                    .background(Color("button"))
                }
                
            }.offset(y: 10)
                .padding(.horizontal, 30.0)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 20){
                    
                    ForEach(scroll_Tabs,id: \.self){tab in
                        
                        //     Tab Button...
                        
                        TabButton(title: tab, id: tab, selectedTab: $selectedTab.onUpdate {
                            if (selectedTab == "Mới nhất") {
                                self.type = ""
                            }
                            if (selectedTab == "Lịch hẹn") {
                                self.type = "2"
                            }
                            if (selectedTab == "Giao dịch") {
                                self.type = "1"
                            }
                            if (selectedTab == "Ưu đãi") {
                                self.type = "4"
                            }
                            loadData()
                        })
                    }
                }
                .padding(.horizontal, 37)
                .padding(.top,10)
            }  .offset(y: 10)
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else
                {
                    if results.count > 0  {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(results){item in
                                RecentRowView(recent: item).environmentObject(UserApiService())
                            }
                        }.offset(y: 30)
                    }else
                    {
                        NoData()
                            .padding(.top, 30)
                    }
                }
                
            })
            Spacer()
        }.onAppear{
            loadData()
        }
    }
    func loadData() {
        self.loading = true
        _ = service.loadNotification(type: type ?? "").done { NotificationList in
            if let items = NotificationList.payload {
                self.results = items
            }
            self.loading = false
        }
    }
}




struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationViewPreview().environmentObject(UserApiService())
    }
}
