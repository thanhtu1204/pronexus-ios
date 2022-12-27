//
//  HomeView.swift
//  ProNexus
//
//  Created by Tú Dev app on 01/11/2021.
//

import SwiftUI
import SwiftyUserDefaults

struct HomeView: View {
    
    @EnvironmentObject var service: ProviderApiService
    @EnvironmentObject var serviceUser: UserApiService
    
    @State var currentIndex: Int = 0
    @State var isOn: Bool = true
    @State var isShowConfirm = false
    @State var rating: Double = 0
    @State var unReadCount: Int = 0
    
    var body: some View {
        
        ZStack (alignment: .top) {
            VStack (alignment: .leading) {
                HeaderHomeView(isOn: $isOn.onUpdate {
                    if (self.isOn){
                        changeStatus(status: true) // bật
                    } else{
                        self.isShowConfirm.toggle()
                    }
                    
                }, rating: $rating, unReadCount: $unReadCount)
                
                ScrollView (showsIndicators: false) {
                    Group { // boc trong group thi se trinh bay duoc > 10 view
                        
                        
                        if let user = Defaults.userLogger
                        {
                            // advisor
                            if user.role == UserRole.advisor.rawValue {
                                CategoryActionHomeAdvisor()
                                
                                // báo cáo hiệu suất
                                PerformanceSection(title: "Báo cáo hiệu suất").environmentObject(ProviderApiService())
                                
                                // lịch hẹn chờ xác nhận
                                MyScheduleView().environmentObject(ProviderApiService())
                                
                                MyAppointmentView().environmentObject(ProviderApiService())
                                // uu dai
                                PromoteView().environmentObject(BannerService())
                                
                                ExpertiseArticleSectionList(title: "Bài viết của tôi").environmentObject(NewsApiService())
                                    .padding(.top, 20)
                            } else
                            {
                                // user normal
                                CategoryActionHomeUser()
                                
                                // lĩnh vực tư vấn
                                ConsultingFieldSection().environmentObject(ClassificationApiService())
                                //                                    .padding(.leading, 37)
                                    .padding(.top, 20)
                                
                                // danh sách cố vấn
                                AdvisorSectionListView(title: "Danh sách cố vấn").environmentObject(ProviderApiService())
                                    .padding(.top, 10)
                                // uu dai
                                PromoteView().environmentObject(BannerService())
                                
                                ExpertiseArticleSectionList(title: "Kiến thức").environmentObject(NewsApiService())
                                    .padding(.top, 20)
                            }
                        }
                        
                    }
                    
                }.onAppear {
                    loadData()
                }.padding(.bottom, 15)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            if $isShowConfirm.wrappedValue {
                CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn tắt trạng thái Sẵn sàng tư vấn không? Nếu đồng ý, bạn sẽ không thể nhận được yêu cầu đặt lịch hẹn.", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {
                    self.isShowConfirm.toggle()
                    changeStatus(status: false) // tắt
                }, onPressBtn2: {
                    self.isOn = true
//                    self.isShowConfirm = false
                }, show: $isShowConfirm)
            }
            
        }.background(Color(hex: "#F9F9F9"))
        .edgesIgnoringSafeArea(.top)
    }
    
    func changeStatus(status: Bool) {
        
        let data: [String: Any] = [
            "IsAvaiable": status,
        ]
        _ = service.updateProfileAdvisor(parameters: data)
    }
    
    func loadData() {
        if let user = Defaults.userLogger
        {
            if user.role == UserRole.advisor.rawValue {
                _ = service.loadProfileAdvisor().done({ rs in
                    self.rating = rs.payload?.advisorAvgRate() ?? 0
                    self.isOn = rs.payload?.isAvaiable ?? false
                })
            } else
            {
                _ = serviceUser.loadProfileCustomer()
            }
        }
        _ = serviceUser.loadNotification(type: "").done({ NotificationList in
            self.unReadCount = NotificationList.unReadCount ?? 0
        })
    }
    
}

struct MyScheduleView: View {
    
    @EnvironmentObject var service: ProviderApiService
    @State var loading = true
    @State var data: [ScheduleCustomerModel]?
    
    var body: some View {
        VStack
        {
            VStack{
                SectionTitleView(title: "Lịch hẹn chờ xác nhận", nextView: ListAppointmentView().environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true) )
            }.padding(.horizontal, 37)
            
            if $loading.wrappedValue {
                SectionLoader()
            } else
            {
                if let items = data {
                    if items.count > 0 {
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            HStack(){
                                ForEach(items) {item in
                                    NavigationLink(destination: {
                                        AppointmentDetailView(id: item.scheduleOrderID ?? 0).environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                    }) {
                                        ItemConfirm(item: item)
                                    }
                                }
                            }.padding(.vertical)
                            
                        }).padding(.leading, 37)
                    } else
                    {
                        NoData(w: getRect().width - 74, h: 80).cornerRadius(15)
                    }
                }
            }
            
        }.onAppear {
            _ = service.loadListScheduleAdvisor(scheduleType: "Pending").done { rs in
                self.data = rs.data
                self.loading = false
            }
        }
    }
}

struct MyAppointmentView:View{
    @EnvironmentObject var service: ProviderApiService
    
    @State var loading = true
    @State var data: [ScheduleCustomerModel]?
    
    var body: some View {
        VStack{
            VStack{
                SectionTitleView(title: "Cuộc hẹn của tôi", nextView: ListAppointmentView().environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true))
            }.padding(.horizontal, 37)
            
            if $loading.wrappedValue {
                SectionLoader()
            } else
            {
                if let items = data {
                    if items.count > 0 {
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            HStack(){
                                ForEach(items) {item in
                                    NavigationLink(destination: {
                                        AppointmentDetailView(id: item.scheduleOrderID ?? 0).environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                    }) {
                                        RowSectionAppointment(item: item)
                                    }
                                    
                                    
                                }
                            }.padding(.vertical, 5)
                            
                        }).padding(.leading, 37)
                    } else
                    {
                        NoData()
                    }
                }
            }
            
        }.onAppear {
            _ = service.loadListScheduleAdvisor(scheduleType: "Done,Approve,InProgress,Cancel").done { rs in
                self.data = rs.data
                self.loading = false
            }
        }
    }
}



struct NewsListSection :View{
    
    @EnvironmentObject var newsService: NewsApiService
    
    //danh sách bài viết nổi bật
    var body: some View {
        Group
        {
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack(spacing: 15){
                    if let results = newsService.newsList.data {
                        
                        ForEach(results) {item in
                            NavigationLink(destination: {
                                NewsDetailView(slug: item.slug ?? "").environmentObject(NewsApiService())
                            }) {
                                //TODO: Thanh xem lại phần này
                                NewsItemRowView(item: item)
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 26)
                .padding(.leading,10)
                .padding(.top, 0)
                .padding(.bottom,10)
            })
        }.padding(.leading, 0.0).onAppear {
            newsService.loadNewsFeature()}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}
