//
//  ProviderViewDetail.swift
//  ProNexus
//
//  Created by thanh cto on 23/10/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import WrappingHStack
import SwiftyUserDefaults

enum ActionState: Int {
    case setup = 0
    case readyForPush = 1
}

struct AdvisorDetailView: View {
    @State var id : String = ""
    @State var show = false
    @State var showLoader = false
    @State var showUpdate = false
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.isPreview) var isPreview
    
    @State var advisorModel = AdvisorModel()
    
    
    // khai bao service
    @ObservedObject var service: ProviderApiService = ProviderApiService()
    
    @ObservedObject var viewModel = ViewModel()
    
    @ObservedObject var chatModel = ChatroomsViewModel()
    
    @State var tabIndex = 0
    @State var isShowPaymentForm = false
    @State var urlAddress = ""
    @State var selections: [Int] = []
    @State var listScheduleEmpty: [ScheduleEmptyModel]?
    @State var isShowConfirmBookingEmpty = false
    @State private var actionState: ActionState? = .setup
    @State var loading = true
    @State var selectedMoment: String?
    @State var selectedDate: Date?
    @State var isBackNav: Bool = false
    @State var navToChatMessage = false
    @State var chatDocId: String?
    @State var favorite = false
    
    var body: some View {
        NavigationView {            
            VStack {
                Header(title: "", contentView: {
                    ButtonIcon(name: "arrow.left", onTapButton: {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    })
                    Spacer()
//                    Button(action: {
//                        if(self.favorite){
//                            self.favorite = false
//                            _ = service.deleteAdvisorFavorite(id: id)
//                        } else{
//                            self.favorite = true
//                            let data: [String: Any] = [
//                                "ProviderId": id
//                            ]
//                            _ = service.advisorFavorite(parameters: data)
//                        }
//                    }, label:{
//
//                        Image(systemName: favorite ? "heart.fill" : "heart").resizable()
//                            .scaledToFit()
//                            .foregroundColor(Color.white)
//                            .frame(width:17, height: 15).padding(.top, 0)
//
//                    })
                    ButtonIcon(name: favorite ? "heart.fill" : "heart", onTapButton: {
                        if(self.favorite){
                            self.favorite = false
                            _ = service.deleteAdvisorFavorite(id: id)
                        } else{
                            self.favorite = true
                            let data: [String: Any] = [
                                "ProviderId": id
                            ]
                            _ = service.advisorFavorite(parameters: data)
                        }
                        
                    })
                })
                ZStack (alignment: .top) {
                    ScrollView {
                        VStack(spacing: 40) {
                            if $loading.wrappedValue {
                                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                            } else
                            {
                                
                                if let model = self.advisorModel
                                {
                                    VStack(alignment: .center, spacing: 20) {
                                        
                                        VStack(alignment: .center, spacing: 4) {
    //
    //                                        WebImage(url: URL(string: model.Avatar()))
    //                                            .resizable()
    //                                            .indicator(.progress)
    //                                            .frame(width: 140, height: 140, alignment: .center)
    //                                            .aspectRatio(contentMode: .fill)
    //                                            .cornerRadius(15)
    //                                            .myShadow()
    //
                                            
                                            WebImage(url: URL(string: model.Avatar()))
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
                                                .frame(width: 140, height: 140)
                                                .cornerRadius(15)
                                                .myShadow()
                                            
                                            
                                            if let fullName = model.fullName() {
                                                Text(fullName).appFont(style: .headline, color: Color(hex: "#4D4D4D")).padding(.vertical, 6)
                                            }
                                            //
                                            
                                            Text(model.jobTitle ?? "")
                                                .myFont(style: .body)
                                                .padding(.leading, 6)
                                                .padding(.trailing, 6)
                                                .padding(.vertical, 4)
                                                .background(Color(hex: "#E6E6E6"))
                                                .foregroundColor(Color(hex: "#808080"))
                                                .cornerRadius(15)
                                            
                                            //
                                            HStack(alignment: .center, spacing: 10) {
                                                ViewShadow(text: "Đã tư vấn", subText: "+\(model.serviceHours ?? 0) giờ")
                                                ViewShadow(text: "Kinh nghiệm", subText: "\(model.yearsExperience ?? 0) năm")
                                                ViewShadow(text: "Đánh giá", subText: "\(model.advisorAvgRate())")
                                            }.padding(.top, 20)
                                            
                                        }
                                        
                                        //chuyen mon
                                        
                                        
                                        
                                        Group {
                                            VStack (alignment: .leading, spacing: 20) {
                                                
                                                //
                                                Text("Chuyên môn")
                                                    .myFont(style: .body).frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                if let list = model.classificationList
                                                {
                                                    WrappingHStack(list) { item in
                                                        Badge(text: item.name ?? "", textColorHex: "#fff", bgColorHex: "").padding(.bottom, 6)
                                                    }
                                                }
                                                
                                                Text("Giới thiệu")
                                                    .myFont(style: .body).frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                
                                                if let aboutMe = model.aboutMe {
                                                    Text(aboutMe)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(Color(hex: "#808080"))
                                                }
                                                
                                                
                                                
                                                HStack (spacing: 40) {
                                                    VStack (alignment: .leading, spacing: 8) {
                                                        Text("Bằng cấp")
                                                            .myFont(style: .body).frame(maxWidth: .infinity, alignment: .leading)
                                                        Text("\(model.jobTitle ?? "")")
                                                            .myFont(style: .caption1).frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                    
                                                    VStack (alignment: .leading, spacing: 8) {
                                                        Text("Tổ chức")
                                                            .myFont(style: .body).frame(maxWidth: .infinity, alignment: .leading)
                                                        Text("\(model.company ?? "")")
                                                            .myFont(style: .caption1).frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                    
                                                }
                                                .offset(x: 0, y: 0)
                                                
                                                
                                                HStack (spacing: 40) {
                                                    VStack (alignment: .leading, spacing: 8) {
                                                        Text("Địa điểm")
                                                            .myFont(style: .body).frame(maxWidth: .infinity, alignment: .leading)
                                                        Text(model.province ?? "")
                                                            .myFont(style: .caption1).frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                    
                                                    VStack (alignment: .leading, spacing: 8) {
                                                        Text("Hình thức")
                                                            .myFont(style: .body).frame(maxWidth: .infinity, alignment: .leading)
                                                                                                            
                                                        HStack (spacing: 6) {
                                                            if model.isOnline ?? false {
                                                                Text("Online")
                                                                    .myFont(style: .caption1).frame(maxWidth: .infinity, alignment: .leading)
                                                            }
                                                            if model.isOffline ?? false {
                                                                Text("Trực tiếp")
                                                                    .myFont(style: .caption1).frame(maxWidth: .infinity, alignment: .leading)
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                                .offset(x: 0, y: 0)
                                                
                                                Spacer()
                                                
                                            }.padding(.all, 20.0)
                                                .frame(width: screenWidth() - 74)
                                                .background(Color("button"))
                                                .cornerRadius(15)
                                                .myShadow()
                                        }
                                        
                                        
                                        //chuyen mon
                                        
                                        VStack (alignment: .leading, spacing: 20) {
                                            CustomTopTabBar(tabIndex: $tabIndex)
                                            
                                            if tabIndex == 0 {
                                                
                                                //chọn lĩnh vực
                                                
                                                Text("Chọn lĩnh vực")
                                                    .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.horizontal, 20)
                                                
                                                if let list = model.classificationList
                                                {
                                                    ScrollView(.horizontal, showsIndicators: false){
                                                        HStack (alignment: .firstTextBaseline) {
                                                            ForEach(list) { item in
                                                                ButtonSelectedCate(item: item, selections: $selections)
                                                                
                                                            }
                                                        }.padding(.horizontal, 20).padding(.vertical, 2)
                                                    }
                                                } else
                                                {
                                                    HStack(alignment: .center) {
                                                        Spacer()
                                                        NoData()
                                                        Spacer()
                                                    }
                                                }
                                                
                                                Divider()
                                                
                                                // co lich trong
                                                HStack {
                                                    Spacer()
                                                    CalendarBookingContentView(list: $listScheduleEmpty, selectedMoment: $selectedMoment, selectedDate: $selectedDate)
                                                    Spacer()
                                                }
                                                
                                                Divider()
                                                
                                                HStack (alignment: .firstTextBaseline, spacing: 8) {
                                                    Text("Phí tư vấn")
                                                        .myFont(style: .body).frame(maxWidth: .infinity, alignment: .leading)
                                                    if let fee = model.priceHours {
                                                        Text("\(fee) /giờ")
                                                            .myFont(style: .body).frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                    
                                                }.padding(.all, 20)
                                            }
                                            else {
                                                SecondView()
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.all, 0)
                                        .frame(width: UIScreen.screenWidth - 74)
                                        .background(Color("button"))
                                        .cornerRadius(15)
                                        .myShadow()
                                        
                                        HStack(){
                                            HStack(spacing: 20){
                                                Button {
                                                    self.navChatDetail()
                                                } label: {
                                                    Image(systemName: "message")
                                                }.frame(width: 60, height: 45)
                                                    .background(Color("button"))
                                                    .cornerRadius(30)
                                                    .myShadow()
                                                
                                            }
                                            
                                            // go payment booking
                                            NavigationLink(destination: PaymentScheduleReview(id: self.id, selections: $selections, selectedDate: selectedDate ?? Date(), selectedMoment: selectedMoment).environmentObject(ProviderApiService())
                                                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), tag: .readyForPush, selection: $actionState)
                                            {
                                                EmptyView()
                                            }
                                            
                                            // go chat detail
                                            if $navToChatMessage.wrappedValue {
                                                NavigationLink(destination:
                                                                Messages(docId: self.chatDocId ?? "")
                                                                .environmentObject(MessagesViewModel())
                                                                .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $navToChatMessage)
                                                {
                                                    EmptyView()
                                                }
                                            }
                                            
                                            Spacer()
//                                            if self.listScheduleEmpty != nil {
//
//                                                Button {
//                                                    self.actionState = .readyForPush
//                                                } label: {
//                                                    Text("Đặt lịch hẹn")
//                                                }.buttonStyle(BlueButton(w: screenWidth() - 156))
//
//                                            } else
//                                            {
//                                                // khong co lich trong
//                                                Button {
//                                                    self.isShowConfirmBookingEmpty = true
//                                                } label: {
//                                                    Text("Đặt lịch hẹn2")
//                                                }.buttonStyle(BlueButton(w: screenWidth() - 156))
//                                            }
                                            
                                            Button {
                                                if checkTodayHaveSchedule()
                                                {
                                                    self.actionState = .readyForPush
                                                } else {
                                                    self.isShowConfirmBookingEmpty = true
                                                }
                                            } label: {
                                                Text("Đặt lịch hẹn")
                                            }.buttonStyle(BlueButton(w: screenWidth() - 156))
                                            
                                            
                                        }.padding(.horizontal, 37)
                                        Spacer()
                                        
                                    }.padding().zIndex(11)
                                } else
                                {
                                    NoData()
                                }
                            }
                            Spacer() //<-- This solved my problem
                        }.padding(.top, 50)
                    }
                    
                    if $isShowConfirmBookingEmpty.wrappedValue {
                        CustomAlertView(title: "Thông báo", msg: "Cố vấn không có lịch trống ngày này, Quý khách vui lòng chọn lịch trống của ngày khác. Quý khách vẫn có thể đặt lịch và chờ cố vấn xác nhận. ", textButton1: "Đồng ý", textButton2: "Quay lại", icon: "ic_complate", onPressBtn1: {
                            self.actionState = .readyForPush
                            
                        }, show: $isShowConfirmBookingEmpty)
                    }
                }
            }
            .navigationBarHidden(true).navigationBarBackButtonHidden(true)
        }
        .onAppear{
            loadData()
        }
    }
    
    func checkTodayHaveSchedule() -> Bool {
        if let date = selectedDate
        {
            if let items = self.listScheduleEmpty {
                for item in items {
                    let start = Date(fromString: (item.startDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
                    let end = Date(fromString: (item.endDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
                    let isOk = date.compare(.isLater(than: start)) && date.compare(.isEarlier(than: end))
                    if isOk {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func navChatDetail() {
        if let user = Defaults.userLogger {
            DispatchQueue.main.async {
                let fromUserAvt = user.profileImageURL ?? ""
                chatModel.createChatroom(fromUserId: user.customerID!,
                                         fromUserName: user.fullName!,
                                         fromUserAvatar: fromUserAvt,
                                         toUserName: advisorModel.fullName(),
                                         toUserId: String(advisorModel.id!),
                                         toUserAvatar: advisorModel.Avatar(), handler: { docId in
                    self.chatDocId = docId
                    self.navToChatMessage = true
                })
            }
        }
    }
    
    func loadData(){
        _ = service.loadProviderDetail(key: id).done { AdvisorDetailModel in
            self.loading = false
            if let item = AdvisorDetailModel.payload {
                self.advisorModel = item
            }
            
        }
        _ = service.loadListScheduleEmptyById(advisorId: id).done { ScheduleListEmptyModel in
            if let items = ScheduleListEmptyModel.list {
                self.listScheduleEmpty = items
            }
        }
        
        //check advisor is favorite
        _ = service.checkAdvisorFavorite(id: String(id)).done { CommonResponseModel in
            self.favorite = CommonResponseModel.ok
        }
    }
    
    func executeDelete() {
        print("Now deleting…")
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

struct SecondView: View{
    var body: some View{
        VStack(alignment: .center){
            NoData()
        }.frame(width: screenWidth() - 60, alignment: .center)
    }
}


struct ViewShadow: View {
    
    var text: String = ""
    var subText: String = ""
    
    var body: some View {
        return ZStack(alignment: .leading) {
            VStack {
                Text(text).foregroundColor(Color(hex: "#808080")).regular(size: 12)
                Text(subText).foregroundColor(Color(hex: "#4D4D4D")).regular(size: 16)
            }
            .padding(.all, 8.0)
            .frame(width: 90, height: 90)
            .background(Color("button"))
            .cornerRadius(15)
            .myShadow()
        }
    }
}

struct CalendarBookingContentView: View {
    
    @Environment(\.calendar) var calendar
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    @Binding var list: [ScheduleEmptyModel]?
    @State var scheduleProviderSessionList: [ScheduleProviderSessionList]?
    @Binding var selectedMoment: String?
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack{
            CalendarView(interval: self.year) { date in
                Text("30")
                    .hidden()
                    .padding(2)
                    .background((selectedDate ?? Date()).compare(.isSameDay(as: date)) ? Color(hex: "#E3F2FF") : .white) // Make your logic
                    .clipShape(Rectangle())
                    .cornerRadius(4)
                    .padding(2)
                    .overlay(
                        Text(String(self.calendar.component(.day, from: date))).appFont(style: .body, color: checkValidDateRange(today: date) ? Color(hex: "#1D74FE") : Color.black)
                    )
                    .onTapGesture {
                        self.selectedDate = date
                        self.selectedMoment = ""
                        self.scheduleProviderSessionList = getDateDetail(date: date)
                    }
            }.onAppear() {
                self.scheduleProviderSessionList = getTodayDetail(date: Date())
            }
            
            if let list = scheduleProviderSessionList
            {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack (alignment: .firstTextBaseline) {
                        ForEach(list) { item in
                            Button(action: {
                                self.selectedMoment = item.session ?? ""
                            }) {
                                Text(AppUtils.translateStatusMoment(text: item.session ?? ""))
                                    .myFont(style: .body, color: self.selectedMoment ==  (item.session ?? "") ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
                            }.buttonStyle(BorderButtonSelected(isSelected: self.selectedMoment ==  (item.session ?? "")))
                            
                        }
                    }.padding(.horizontal, 20).padding(.vertical, 2)
                }
            }
            Spacer()
        }.padding(.top, 20)
            .background(Color.white)
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
    
    func getDateDetail(date: Date) -> [ScheduleProviderSessionList] {
        if let items  = list {
            for item in items {
                let start = Date(fromString: (item.startDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
                let end = Date(fromString: (item.endDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
                let isOk = date.compare(.isLater(than: start)) && date.compare(.isEarlier(than: end))
                if isOk {
                    return item.scheduleProviderSessionList ?? []
                }
            }
        }
        return []
    }
    
    func getTodayDetail(date: Date) -> [ScheduleProviderSessionList] {
        if let items  = list {
            for item in items {
                let start = Date(fromString: (item.startDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
//                let end = Date(fromString: (item.endDate ?? "")[0..<10], format: .custom("yyyy-M-dd")) ?? Date()
                let isOk = date.compare(.isSameDay(as: start))
                if isOk {
                    return item.scheduleProviderSessionList ?? []
                }
            }
        }
        return []
    }
}


struct TabBarButtonRadius: View {
//    var w: CGFloat
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .myFont(style: .body, color: isSelected ? Color(hex: "#333") :  Color.black)
            .frame(width: ((screenWidth() - 70) / 2), height: 40)
            .background(RoundedCorners(color: isSelected ? Color(hex: "#fff") :  Color(hex: "#e2e2e2"), tl: 15, tr: 15, bl: 0, br: 0))
    }
}

struct TabBarButtonRadius2: View {
//    var w: CGFloat
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .myFont(style: .body, color: isSelected ? Color(hex: "#333") :  Color.black)
            .frame(width: ((screenWidth() - 70) / 3), height: 40)
            .background(RoundedCorners(color: isSelected ? Color(hex: "#fff") :  Color(hex: "#e2e2e2"), tl: 15, tr: 15, bl: 0, br: 0))
    }
}


struct CustomTopTabBar: View {
    
    
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 0) {
            TabBarButtonRadius(text: "Dịch vụ", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButtonRadius(text: "Bài viết", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            
        }
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}


#if DEBUG
struct AdvisorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AdvisorDetailView(id: "262").environmentObject(ProviderApiService()).navigationBarHidden(true)
    }
}
#endif
