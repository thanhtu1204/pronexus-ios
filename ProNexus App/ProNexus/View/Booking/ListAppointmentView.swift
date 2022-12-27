//
//  ListAppointmentView.swift
//  ProNexus
//
//  Created by IMAC on 11/3/21.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftyUserDefaults


struct Tabs: Identifiable {
    var id = UUID().uuidString
    var tab : String
}

var tabsItemsListAppoitment_Customer = [
    
    Tab(id: "1", tab: "Sắp tới"),
    Tab(id: "2", tab: "Đã qua"),
]

var tabsItemsListAppoitment_Advisor = [
    Tab(id: "1", tab: "Sắp tới"),
    Tab(id: "2", tab: "Đã qua"),
    Tab(id: "3", tab: "Lịch trống"),
]

class SearchAppointmentViewModel: ObservableObject {
    @Published var text: String = ""
}

struct ListAppointmentView: View {
    
    @State var itemIdEdit: Int?
    @State var sessionList: [String] = []
    
    var item : ScheduleEmptyModel?
    
    @State var selectedTab = "1"
    
    @State var message = ""
    @State var isShowDelete = false
    @State var isShowAlertError = false
    @State var listEmptyAppointment: [ScheduleEmptyModel]?
    @State var loadinglistEmptyAppointment = true
    @State var isShowModalEditSchedule = false
    @State var selectedDate: Date = Date()
    
    @State var listIncomingData: [ScheduleCustomerModel]?
    @State var isSearch = false
    @State var isLoadingIncomingData = false
    
    @ObservedObject private var vm = SearchAppointmentViewModel()
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var service: ProviderApiService
    
    var body: some View {        
        
        ZStack (alignment: .top) {
            
            VStack (alignment: .center) {
                HeaderView(onTapButtonLeft: {
                    self.presentationMode.wrappedValue.dismiss()
                }, titleHeader: "Danh sách lịch hẹn") {
                    
                }.padding(.horizontal, 22).offset(x: 0, y: -3)
                // end header
                
                // input search
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray)
                            .frame(height: 18)
                        
                        TextField("Bạn đang tìm ai", text: $vm.text).appFont(style: .caption1, weight: .regular, size: 14)
                            .onReceive(
                                vm.$text
                                    .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                            ) {
//                                guard !$0.isEmpty else { return }
                                print(">> searching for: \($0)")
                                self.isSearch = true
                                if selectedTab == "1" {
                                    loadDataByStatus(status: "Pending,Approve,InProgress,Cancel")
                                }
                                if selectedTab == "2" {
                                    loadDataByStatus(status: "Done")
                                }
                            }
                        
                        if self.vm.text.count > 0 {
                            Button {
                                self.vm.text = ""
                            } label: {
                                
                                if $isSearch.wrappedValue {
                                    ActivityIndicator(isAnimating: true)
                                        .configure { $0.color = .gray }
                                        .padding(.trailing, -10)
                                } else {
                                    Image(systemName: "xmark.circle.fill").resizable().frame(width: 16, height: 16).foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, -10)
                                }
                            }
                        }
                    }
                    .padding(10)
                    .padding(.horizontal, 15)
                    .frame(height: 49)
                    .background(Color.white)
                    .cornerRadius(30)
                    .myShadow()
                }.padding(.horizontal, 37)
                    .offset(x: 0, y: -5).zIndex(1111)
                
                
                VStack (alignment: .center) {
                    CalendarAdvisorScheduleView().padding(.vertical, 20)
                }
                .padding(.all, 0)
                .frame(width: UIScreen.screenWidth - 74, alignment: .center)
                .background(Color.white)
                .cornerRadius(15)
                .myShadow()
                
                VStack(){
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 15){
                            
                            if let user = Defaults.userLogger {
                                if user.role == UserRole.advisor.rawValue {
                                    ForEach(tabsItemsListAppoitment_Advisor){tab in
                                        
                                        // Tab Button...
                                        TabButton(title: tab.tab, id: tab.id, selectedTab: $selectedTab)
                                    }
                                } else {
                                    ForEach(tabsItemsListAppoitment_Customer){tab in
                                        
                                        // Tab Button...
                                        TabButton(title: tab.tab, id: tab.id, selectedTab: $selectedTab)
                                    }
                                }
                            }
                            
                            
                        }
                        
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 37)
                    
                    ScrollView(showsIndicators: false) {
                        
                        // Tab view
                        
                        VStack(spacing: 15){
                            if selectedTab == "1" {
                                ListAppointmentUpComming(data: $listIncomingData, loading: $isLoadingIncomingData).environmentObject(service).onAppear() {
                                    loadDataByStatus(status: "Pending,Approve,InProgress,Cancel")
                                }
                            }
                            if selectedTab == "2" {
//                                ListAppointment_Tab_Complete().environmentObject(service)
                                ListAppointmentUpComming(data: $listIncomingData, loading: $isLoadingIncomingData).environmentObject(service).onAppear() {
                                    loadDataByStatus(status: "Done")
                                }
                            }
                            if selectedTab == "3" {
                                ListEmptyAppointment(data: $listEmptyAppointment, itemIdEdit: $itemIdEdit, isShowDelete: $isShowDelete, loading: $loadinglistEmptyAppointment, isShowModalEditSchedule: $isShowModalEditSchedule, sessionList: $sessionList, selectedDate: $selectedDate)
                            }
                            
                        }
                        .padding(.horizontal, 37)
                        .padding(.top, 0)
                        .padding(.bottom, 90)
                        
                    }
                    Spacer()
                }
                
            }
            .onAppear {
                loadListScheduleEmptyById()
            }
            
            if $isShowDelete.wrappedValue {
                CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn xoá lịch trống đã tạo?", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {onDelete()}, onPressBtn2: {}, show: $isShowDelete)
            }
            
            if $isShowModalEditSchedule.wrappedValue {
                AdvisorCreateSchedulePopupView(show: $isShowModalEditSchedule.onUpdate{
                    print("Đóng popup sửa lịch")
                    loadListScheduleEmptyById()
                }, selections: sessionList, selectedDate: selectedDate, editMode: true, ScheduleProviderId: String(self.itemIdEdit ?? 0))
                    .environmentObject(ProviderApiService())
            }
        
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
//        .edgesIgnoringSafeArea(.all)
    }
    
    func onDelete(){
        _ = service.deleteAppointment(id: "\(self.itemIdEdit ?? 0)").done { response in
            loadListScheduleEmptyById()
            if response.ok {
                
            } else {
                self.message = "Xảy ra lỗi không thể xoá lịch trống này"
                self.isShowAlertError = true
            }
        }
        isShowDelete = false
        //        self.presentationMode.wrappedValue.dismiss()
    }
    
    func loadListScheduleEmptyById() {
        self.loadinglistEmptyAppointment = true
        
        if let user = Defaults.userLogger {
            if user.role == UserRole.advisor.rawValue {
                _ = service.loadListScheduleEmptyById(advisorId: user.providerID ?? "").done { rs in
                    self.loadinglistEmptyAppointment = false
                    if let data = rs.list {
                        if data.count > 0 {
                            self.listEmptyAppointment = data
                        }
                    }
                    
                }
            }
        }
    }
    
    // load list danh sách lịch sắp tới
    func loadDataByStatus(status: String) {
        if let user = Defaults.userLogger {
            if user.role == UserRole.advisor.rawValue {
                _ = service.loadListScheduleAdvisor(scheduleType: status, keyword: vm.text).done { rs in
                    self.isLoadingIncomingData = false
                    self.isSearch = false
                    self.listIncomingData = rs.data
                    
                }
            } else {
                _ = service.loadListScheduleCustomer(scheduleType: status, keyword: vm.text).done { rs in
                    self.isLoadingIncomingData = false
                    self.isSearch = false
                    self.listIncomingData = rs.data
                }
            }
        }
    }
}


struct ListAppointmentUpComming:View {
    
    @EnvironmentObject var service: ProviderApiService
    @Binding var data: [ScheduleCustomerModel]?
    @Binding var loading: Bool
    
    var body: some View {
        VStack (alignment: .center, spacing: 15) {
            
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
            }
            else
            {
                if let items = data {
                    if items.count > 0 {
                        ForEach(items){item in
                            NavigationLink(destination: {
                                AppointmentDetailView(id: item.scheduleOrderID ?? 0).environmentObject(ProviderApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                            }) {
                                ItemAppointmentView(item: item)
                            }
                            
                        }
                    }
                    else
                    {
                        NoData()
                    }
                }
            }
        }
        .padding(.bottom, 5).edgesIgnoringSafeArea(.top)
    }
}



struct ListEmptyAppointment: View {
    
    @Binding var data: [ScheduleEmptyModel]?
    @Binding var itemIdEdit: Int?
    @Binding var isShowDelete: Bool
    @Binding var loading: Bool
    @Binding var isShowModalEditSchedule: Bool
    @Binding var sessionList: [String]
    @Binding var selectedDate: Date
    
    var body: some View {
        
        VStack {
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
            } else {
                if let itemsEmpty = data {
                    ForEach(itemsEmpty) { item in
                        ItemEmptyAppointment(item: item, itemIdEdit: $itemIdEdit, isShowDelete: $isShowDelete, isShowModalEditSchedule: $isShowModalEditSchedule, sessionList: $sessionList, selectedDate: $selectedDate)
                    }
                }
                else
                {
                    NoData()
                }
            }
            
        }
    }
}

struct ItemEmptyAppointment: View {
    
    var item : ScheduleEmptyModel
    @State var expand = false
    @Binding var itemIdEdit: Int?
    
    @State var message = ""
    @Binding var isShowDelete: Bool
    @State var isShowAlertError = false
    @Binding var isShowModalEditSchedule: Bool
    @Binding var sessionList: [String]
    @Binding var selectedDate: Date
    
    @EnvironmentObject var service: ProviderApiService
    
    var body: some View {
        ZStack (alignment: .trailing) {
            
            HStack() {
                if let startDate = item.startDate{
                    Text("Ngày \((Date(fromString: startDate[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy")))!)")
                        .appFont(style: .body, size: 12, color: Color(hex: "#808080"))
                }
                
                Spacer()
                HStack{ Divider()}.frame(alignment:.center)
                Spacer()
                
                HStack(alignment: .firstTextBaseline) {
                    if let items = item.scheduleProviderSessionList {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, text in
                            Text("\(AppUtils.translateStatusMoment(text: text.session ?? ""))")
                                .appFont(style: .body, weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                            if (items.count > 0 && index != items.count - 1) {
                                Text("|")
                                    .appFont(style: .body, weight: .bold, size: 12, color: Color(hex: "#808080"))
                            }
                        }
                    }
                    Spacer()
                }
                
                Spacer()
                Button {
                    self.expand.toggle()
                    self.sessionList = []
                    if let id = item.scheduleAdvisorID {
                        itemIdEdit = id
                        selectedDate = Date(fromString: (item.startDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
                        // build sessionList để bắn ra popup edit
                        for item in item.scheduleProviderSessionList ?? [] {
                            print("item", item.session ?? "")
                            if let session = item.session {
                                self.sessionList.append(session)
                            }
                        }
                        
                    }
                } label: {
                    Image("ic_more").padding(5)
                }
            }
            .padding(.horizontal, 17)
            VStack {
                if expand && itemIdEdit == item.scheduleAdvisorID {
                    VStack(alignment: .center){
                        if (Date(fromString: (item.startDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()).compare(.isLater(than: Date())) {
                            Text("Sửa").appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080")).onTapGesture {
                                self.isShowModalEditSchedule = true
                                self.expand.toggle()
                            }.padding(.top, 5)
                            Divider()
                        }
                        Button("Xoá") {
                            isShowDelete = true
                        }
                        .onTapGesture {
                            //                          selectCatName = "Sửa"
                            self.expand.toggle()
                        }.padding(.bottom, 5)
                            .appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080"))
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .frame(width: 70, alignment: .center)
                    .cornerRadius(8)
                    .padding(.trailing, 37)
                    .myShadow()
                    
                }
            }
            .frame(width: 70, height: 40, alignment: .trailing)
            .zIndex(999)
            
        }
        .frame(width: UIScreen.screenWidth - 74)
        .padding(.vertical, 17)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
    }
}



struct ItemAppointmentView: View {
    
    var item : ScheduleCustomerModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 15){
            
            // Making it as clickable Button....
            
            if let image = item.mediaURL{
                WebImage(url: URL(string: image))
                    .resizable()
                    .placeholder {
                        Image("ic_picture_circle")
                    }
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFill()
                    .foregroundColor(Color(hex: "#4C99F8"))
                    .frame(width: 60, height: 60)
                    .padding(0)
                    .clipShape(Circle())
            }
            
            VStack{
                VStack (alignment: .leading){
                    HStack(alignment: .center, content: {
                        Text("\(item.firstName!) \(item.lastName!)")
                            .bold(size: 12, color: Color(hex: "#4D4D4D"))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        if(item.scheduleType == "Pending") {
                            Badge(text: "\(AppUtils.translateAppointmentOrderStatus(text: item.scheduleType ?? ""))", textColorHex: "#fff", bgColorHex: "#FFB300", textSize: 10.0)
                        } else {
                            Badge(text: "\(AppUtils.translateAppointmentOrderStatus(text: item.scheduleType ?? ""))", textColorHex: "#fff", bgColorHex: "#49D472", textSize: 10.0)
                        }
                        
                    })
                    
                    Text(item.jobTitle ?? "")
                        .appFont(style: .body, size: 12, color: Color(hex: "#4D4D4D"))
                    
                }
                Divider()
                HStack() {
                    Image("ic_clock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(height: 10)
                    if let classificationList = item.classificationList{
                        ForEach(classificationList){item in
                            Text(item.name!)
                                .regular(size: 10, color: Color(hex: "#808080"))
                            
                        }
                        
                    }
                    Image("ic_calendar")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(height: 10)
                    
                    if let startHour = item.startHour{
                        Text("\(buildTime(startHour: startHour, offset: item.adviseHours ?? 0))").appFont(style: .body, size: 10)
                    }
                    
                    if let startDate = item.startDate{
                        Text("\((Date(fromString: startDate[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yy")))!)")
                            .appFont(style: .body, size: 10, color: Color(hex: "#808080"))
                    }                    
                }
                
            }
            
            .padding(.top, 10)
            .padding(.bottom, 10)
            
        }
        .padding(.horizontal, 17)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
        .offset(x: 0, y: 30)
    }
    
    func buildTime(startHour: String, offset: Int) -> String
    {
        return "\((Date(fromString: "16 July 1972 \(startHour):00", format: .custom("dd MMM yyyy HH:mm:ss"))?.toString(format: .custom("HH:mm")))!) - \((Date(fromString: "16 July 1972 \(startHour):00", format: .custom("dd MMM yyyy HH:mm:ss"))?.adjust(.hour, offset: offset).toString(format: .custom("HH:mm")))!)"
    }
}


struct CalendarAdvisorScheduleView: View {
    
    @Environment(\.calendar) var calendar
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    @ObservedObject var service: ProviderApiService = ProviderApiService()
    
    @State var list: [ScheduleEmptyModel]?
    //    @Binding var selected: Date
    
    var body: some View {
        VStack{
            CalendarView(interval: self.year) { date in
                Text("30")
                    .hidden()
                    .padding(2)
                //                    .background((selectedDate ?? Date()).compare(.isSameDay(as: date)) ? Color(hex: "#E3F2FF") : .white) // Make your logic
                    .clipShape(Rectangle())
                    .cornerRadius(4)
                    .padding(2)
                    .overlay(
                        Text(String(self.calendar.component(.day, from: date))).appFont(style: .body, color: checkValidDateRange(today: date) ? Color(hex: "#1D74FE") : Color.black)
                    )
                    .onTapGesture {
                        
                    }
            }
        }.onAppear {
            loadData()
        }
    }
    
    func loadData() {
        if let user = Defaults.userLogger {
            if user.role == UserRole.advisor.rawValue {
                _ = service.loadListScheduleEmptyById(advisorId: user.providerID ?? "").done { rs in
                    if let data = rs.list {
                        if data.count > 0 {
                            self.list = data
                        }
                    }
                    
                }
            }
        }
    }
    
    func checkValidDateRange(today: Date) -> Bool {
        if let items  = list {
            for item in items {
                let start = Date(fromString: (item.startDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
                let end = Date(fromString: (item.endDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
                let isOk = today.compare(.isLater(than: start)) && today.compare(.isEarlier(than: end))
                if isOk {
                    return true
                }
            }
        }
        return false
    }
}

struct ListAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Calendar))
            ListAppointmentView().environmentObject(ProviderApiService())
        }
    }
}
