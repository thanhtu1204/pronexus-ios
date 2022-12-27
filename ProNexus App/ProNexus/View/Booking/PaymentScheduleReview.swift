//
//  PaymentScheduleReview.swift
//  ProNexus
//
//  Created by thanh cto on 13/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine
import WrappingHStack

struct PaymentScheduleReview: View {
    @State var id : String
    @State var show = false
    @State var showLoader = false
    @State var showUpdate = false
    @Binding var selections: [Int]
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.isPreview) var isPreview
    
    @State var advisorModel = AdvisorModel()
    
    var customerCreateScheduleModelResponse = CustomerCreateScheduleModelResponse() // model customer đặt lịch
    
    // khai bao service
    @EnvironmentObject var service: ProviderApiService
    
    @ObservedObject var viewModel = ViewModel()
    
    @ObservedObject var logger = LoggerModelViewModel()
    
    @State var tabIndex = 0
    
    @State var isShowPaymentForm = false
    @State var urlAddress = "http://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder"
    
    
    @State var AdviseTypes: [ButtonViewModel] = [
        ButtonViewModel(id: "Online", name: "Online"),
        ButtonViewModel(id: "Offline", name: "Trực tiếp")
    ]
    
    @State var TimeTableMorning: [ButtonViewModel] = [
        ButtonViewModel(id: "08:00", name: "08:00"),
        ButtonViewModel(id: "08:30", name: "08:30"),
        ButtonViewModel(id: "09:00", name: "09:00"),
        ButtonViewModel(id: "09:30", name: "09:30"),
        ButtonViewModel(id: "10:00", name: "10:00"),
        ButtonViewModel(id: "10:30", name: "10:30"),
        ButtonViewModel(id: "11:00", name: "11:00"),
        ButtonViewModel(id: "11:30", name: "11:30"),
        ButtonViewModel(id: "12:00", name: "12:00"),
    ]
    
    @State var TimeTableAfternoon: [ButtonViewModel] = [
        ButtonViewModel(id: "12:00", name: "12:00"),
        ButtonViewModel(id: "12:30", name: "12:30"),
        ButtonViewModel(id: "13:00", name: "13:00"),
        ButtonViewModel(id: "13:30", name: "13:30"),
        ButtonViewModel(id: "14:00", name: "14:00"),
        ButtonViewModel(id: "14:30", name: "14:30"),
        ButtonViewModel(id: "15:00", name: "15:00"),
        ButtonViewModel(id: "15:30", name: "15:30"),
        ButtonViewModel(id: "16:00", name: "16:00"),
        ButtonViewModel(id: "16:30", name: "16:30"),
        ButtonViewModel(id: "17:00", name: "17:00"),
        ButtonViewModel(id: "17:30", name: "17:30"),
        ButtonViewModel(id: "18:00", name: "18:00"),
    ]
    
    @State var TimeTableEvening: [ButtonViewModel] = [
        ButtonViewModel(id: "18:00", name: "18:00"),
        ButtonViewModel(id: "18:30", name: "18:30"),
        ButtonViewModel(id: "19:00", name: "19:00"),
        ButtonViewModel(id: "19:30", name: "19:30"),
        ButtonViewModel(id: "20:00", name: "20:00"),
        ButtonViewModel(id: "20:30", name: "20:30"),
        ButtonViewModel(id: "21:00", name: "21:00"),
    ]
    
    @State var TimeTableAllDay: [ButtonViewModel] = [
        ButtonViewModel(id: "08:00", name: "08:00"),
        ButtonViewModel(id: "08:30", name: "08:30"),
        ButtonViewModel(id: "09:00", name: "09:00"),
        ButtonViewModel(id: "09:30", name: "09:30"),
        ButtonViewModel(id: "10:00", name: "10:00"),
        ButtonViewModel(id: "10:30", name: "10:30"),
        ButtonViewModel(id: "11:00", name: "11:00"),
        ButtonViewModel(id: "11:30", name: "11:30"),
        ButtonViewModel(id: "12:00", name: "12:00"),
        ButtonViewModel(id: "12:30", name: "12:30"),
        ButtonViewModel(id: "13:00", name: "13:00"),
        ButtonViewModel(id: "13:30", name: "13:30"),
        ButtonViewModel(id: "14:00", name: "14:00"),
        ButtonViewModel(id: "14:30", name: "14:30"),
        ButtonViewModel(id: "15:00", name: "15:00"),
        ButtonViewModel(id: "15:30", name: "15:30"),
        ButtonViewModel(id: "16:00", name: "16:00"),
        ButtonViewModel(id: "16:30", name: "16:30"),
        ButtonViewModel(id: "17:00", name: "17:00"),
        ButtonViewModel(id: "17:30", name: "17:30"),
        ButtonViewModel(id: "18:00", name: "18:00"),
        ButtonViewModel(id: "18:30", name: "18:30"),
        ButtonViewModel(id: "19:00", name: "19:00"),
        ButtonViewModel(id: "19:30", name: "19:30"),
        ButtonViewModel(id: "20:00", name: "20:00"),
        ButtonViewModel(id: "20:30", name: "20:30"),
        ButtonViewModel(id: "21:00", name: "21:00")
    ]
    
    @State var selectionsAdviseType: String? = nil
    @State var selectTime: String? = nil
    @State var selectedDate: Date = Date()
    @State var hour: Int = 1
    @State var price: Double = 0
    @State var note: String = ""
    @State var totalPrice: Double = 0
    @State var totalPayment: Double = 0
    @State var paymentOk = false
    @State var paymentFail = false
    @State var isChooseBank = false
    @State var isErrorShow = false
    @State var errorMessage = ""
    @State var selectedBankCode: String?
    @State var loading = true
    @State var selectedMoment: String?
    @State var scheduleCustomerModel: ScheduleCustomerModel = ScheduleCustomerModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .top) {
                    // HEADER
                    Header(title: "Thông tin lịch hẹn", contentView: {
                        ButtonIcon(name: "arrow.left", onTapButton: {
                            self.presentationMode.wrappedValue.dismiss()
                            
                        })
                        Spacer()
                    })
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        VStack(spacing: 40) {
                            if let model = self.advisorModel
                            {
                                ContainerView(loading: $loading)
                                {
                                    VStack(alignment: .center, spacing: 20) {
                                        
                                        //                                    AdvisorInfo(item: model)
                                        ProfileFrame(info: scheduleCustomerModel)
                                        
                                        //chuyen mon
                                        
                                        VStack (alignment: .leading, spacing: 20) {
                                            
                                            //
                                            Group {
                                                Text("Chọn lĩnh vực")
                                                    .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                if let list = self.advisorModel.classificationList
                                                {
                                                    WrappingHStack(list) { item in
                                                        ButtonSelectedCate(item: item, selections: $selections).padding(.bottom, 6)
                                                    }
                                                }
                                                
                                                Divider()
                                                
                                                Text("Hình thức")
                                                    .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                if let list = self.AdviseTypes
                                                {
                                                    HStack (alignment: .firstTextBaseline) {
                                                        ForEach(list) { item in
                                                            ButtonSelectedType(item: item, selectionsAdviseType: $selectionsAdviseType)
                                                        }
                                                    }
                                                }
                                                
                                                Divider()
                                                
                                                Text("Chọn thời gian")
                                                    .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                //                                            CalendarAdvisorCreateScheduleView( selected: $selectedDate)
                                                
                                                CalendarBookingReviewContentView(selectedDate: $selectedDate)
                                                
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack (alignment: .firstTextBaseline) {
                                                        
                                                        if self.selectedMoment == "Morning" {
                                                            ForEach(TimeTableMorning) { item in
                                                                TimeViewSelect(item: item, selectTime: $selectTime)
                                                            }
                                                        }
                                                        
                                                        if self.selectedMoment == "Afternoon" {
                                                            ForEach(TimeTableAfternoon) { item in
                                                                TimeViewSelect(item: item, selectTime: $selectTime)
                                                            }
                                                        }
                                                        
                                                        if self.selectedMoment == "Evening" {
                                                            ForEach(TimeTableEvening) { item in
                                                                TimeViewSelect(item: item, selectTime: $selectTime)
                                                            }
                                                        }
                                                        
                                                        if self.selectedMoment.isEmptyOrNil || self.selectedMoment == "AllDay" {
                                                            ForEach(TimeTableAllDay) { item in
                                                                TimeViewSelect(item: item, selectTime: $selectTime)
                                                            }
                                                        }
                                                    }.padding(.vertical, 2)
                                                }
                                                
                                                Group {
                                                    Divider()
                                                    HStack {
                                                        Text("Số giờ tư vấn")
                                                            .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                        Spacer()
                                                        HStack {
                                                            Button(action:{
                                                                if self.hour > 0 {
                                                                    self.hour -= 1
                                                                    self.totalPrice = Double((model.priceHours ?? 0) * self.hour)
                                                                    self.totalPayment = self.totalPrice
                                                                }
                                                            }, label: {
                                                                Image(systemName: "minus.circle.fill").resizable().scaledToFit().frame(width: 20, height: 20).foregroundColor(Color(hex: "#B3B3B3"))
                                                            })
                                                            Text("\(hour)")
                                                                .appFont(style: .body, size: 12, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .center).padding(2).background(Color(hex: "#E3F2FF"))
                                                                .cornerRadius(15).padding(4)
                                                            Button(action:{
                                                                self.hour += 1
                                                                self.totalPrice = Double((model.priceHours ?? 0) * self.hour)
                                                                self.totalPayment = self.totalPrice
                                                            }, label: {
                                                                Image(systemName: "plus.circle.fill").resizable().scaledToFit().frame(width: 20, height: 20).foregroundColor(Color(hex: "#B3B3B3"))
                                                            })
                                                        }.frame(width: 100, alignment: .center)
                                                        
                                                    }
                                                    Divider()
                                                    
                                                    HStack {
                                                        Text("Tổng phí tư vấn")
                                                            .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                        Spacer()
                                                        Text("\(model.priceHours ?? 0)")
                                                            .appFont(style: .body, weight: .regular, size: 12, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                    
                                                    TextField("Nhập ghi chú", text: $note)
                                                        .appFont(style: .body)
                                                        .padding(.top,5).textFieldStyle(RoundedTextFieldStyle())
                                                    
                                                }
                                            }
                                        }.padding(.all, 20.0)
                                            .frame(width: screenWidth() - 74)
                                            .background(Color("button"))
                                            .cornerRadius(15)
                                            .myShadow()
                                        
                                        
                                        VStack() {
                                            HStack {
                                                Text("Tổng phí tư vấn")
                                                    .appFont(style: .body, weight: .regular, size: 12, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                Spacer()
                                                Text(String(totalPrice).convertDoubleToCurrency())
                                                    .appFont(style: .body, weight: .regular, size: 12, color: Color(hex: "#4D4D4D"))
                                            }
                                            
                                            Divider()
                                            
                                            HStack {
                                                Text("Tổng tiền thanh toán")
                                                    .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                                                Spacer()
                                                Text(String(totalPayment).convertDoubleToCurrency())
                                                    .appFont(style: .body, weight: .regular, size: 14, color: Color(hex: "#4C99F8"))
                                            }
                                        }
                                        .padding(.all, 20.0)
                                        .frame(width: screenWidth() - 74)
                                        .background(Color("button"))
                                        .cornerRadius(15)
                                        .myShadow()
                                        
                                        Button(
                                            action: {
                                                if isValidForm() {
                                                    self.isChooseBank = true
                                                }
                                            },
                                            label: { Text("Thanh toán") }
                                        ).buttonStyle(BlueButton())
                                        Spacer()
                                        
                                    }.padding()
                                }
                            }
                            Spacer() //<-- This solved my problem
                        }
                    }.padding(.top, 50)
                    
                    if $isShowPaymentForm.wrappedValue {
                        VStack(spacing: 0) {
                            VStack {
                                ZStack(alignment: .center) {
                                    HStack(spacing: 0) {
                                        //button left
                                        Button(action: {
                                            self.isShowPaymentForm.toggle()
                                        }, label: {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.white)
                                        }).frame(width: 50, alignment: .center)
                                        
                                        Spacer()
                                        HStack(alignment: .center, spacing: 0) {
                                            Text("Thanh toán đặt lịch")
                                                .appFont(style: .body,weight: .regular, size: 20, color: Color(.white)).padding(.trailing,40)
                                        }
                                        
                                        Spacer()
                                        
                                    }
                                    
                                }.background(
                                    Image("bg_header")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.screenWidth, height: 180)
                                )
                            }
                            .padding(.bottom, 40)
                            .zIndex(9999)
                            
                            if !self.urlAddress.isBlank{
                                WebView(url: .publicUrl, urlAddress: urlAddress, viewModel: viewModel)
                            }
                            
                        }
                        .background(Color(hex: "#FFFFFF"))
                        .onReceive(self.viewModel.showLoader.receive(on: RunLoop.main)) { value in
                            self.showLoader = value
                        }.onReceive(self.viewModel.lastUrlRequest.receive(on: RunLoop.main)) { value in
                            print("Last URL Request =>> ", value)
                            logger.saveLog(userId: getIdByRole(), name: "Thanh toán đặt lịch", message: value) {
                                
                            }
                            if let responseCode = getQueryStringParameter(url: value, param: "vnp_ResponseCode")
                            {
                                self.showLoader = false
                                self.isShowPaymentForm.toggle()
                                
                                if responseCode == "00" {
                                    print("responseCode", responseCode)
                                    self.paymentOk = true
                                } else
                                {
                                    self.paymentFail = true
                                    self.showLoader = false
                                }
                            }
                        }.zIndex(9998)
                    }
                    
                    // A simple loader that is shown when WebView is loading any page and hides when loading is finished.
                    if showLoader {
                        Loader().zIndex(9999).padding(.top, 100)
                    }
                    
                    if $paymentOk.wrappedValue {
                        CustomAlertView(title: "Hoàn tất", msg: "Cuộc hẹn của bạn đã được lên lịch thành công. Hãy trao đổi trước với cố vấn, để đạt hiệu suất tốt nhất.", textButton1: "Xem chi tiết", textButton2: "Về trang chủ", icon: "ic_complate", show: $paymentOk)
                    }
                    
                    if $paymentFail.wrappedValue {
                        CustomAlertView(title: "Chưa hoàn tất", msg: "Cuộc hẹn của bạn chưa hoàn tất. Hãy kiểm tra lại phương thức thanh toán và thực hiện lại", textButton1: "Thử lại", textButton2: "Để sau", icon: "ic_un_complate", show: $paymentFail)
                    }
                    
                    NavigationLink (isActive: $isChooseBank) {
                        BankListView(selectedBankCode: $selectedBankCode.onUpdate(onCallBackSelectedBank), isNavigationView: true).environmentObject(BankListApiService()).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    } label: {
                        EmptyView()
                    }
                    
                    if $isErrorShow.wrappedValue
                    {
                        CustomAlertView(title: "Thông báo", msg: errorMessage,  textButton2: "Đóng", icon: "ic_un_complate", show: $isErrorShow)
                    }
                    
                }
                .navigationBarHidden(true).navigationBarBackButtonHidden(true)
            }.onAppear{
                loadData()
                
            }
            //        .onReceive(Just(selectedBankCode)) {    // << subscribe
            //            print(">> selectedBankCode: \($0)") // sau khi chọn bank thì đóng view + request tạo order
            //            if let bankCode = $0 {
            //                if self.isChooseBank == true {
            //                    print(">> Create Order: \(bankCode)")
            //                    self.isChooseBank = false
            //                    requestCreateOrderBooking()
            //                }
            //            }
            //        }
        }
    }
    
    func onCallBackSelectedBank() {
        print(">> selectedBankCode:", selectedBankCode)
        if let bankCode = selectedBankCode {
            requestCreateOrderBooking(bankCode: bankCode)
            self.selectedBankCode = nil
        }
    }
    
    func loadData(){
        if isPreview {
            self.id = "258"
            //            self.id = "264"
        }
        _ = service.loadProviderDetail(key: id).done { AdvisorDetailModel in
            if let item = AdvisorDetailModel.payload {
                self.advisorModel = item
                //
                self.scheduleCustomerModel.advisorName = self.advisorModel.fullName()
                self.scheduleCustomerModel.advisorMediaUrl = self.advisorModel.mediaUrl
                self.scheduleCustomerModel.advisorProvince = self.advisorModel.province
                self.scheduleCustomerModel.price = self.advisorModel.priceHours
                self.scheduleCustomerModel.rating = self.advisorModel.advisorAvgRate()
                
                self.totalPrice = Double((self.advisorModel.priceHours ?? 0) * self.hour)
                self.totalPayment = self.totalPrice
            }
            self.loading = false
        }
        
    }
    
    func isValidForm() -> Bool {
        if self.selections.count == 0  {
            showAlert(text: "Bạn chưa chọn lĩnh vực")
            return false
        }
        else if (self.selectionsAdviseType.isEmptyOrNil){
            showAlert(text: "Bạn chưa chọn hình thức")
            return false
        }
        else if (self.hour == 0){
            showAlert(text: "Bạn chưa chọn số giờ tư vấn")
            return false
        } else if (self.selectTime.isEmptyOrNil){
            showAlert(text: "Bạn chưa chọn thời gian")
            return false
        }
        return true
    }
    
    func showAlert(text: String) {
        self.isErrorShow = true
        self.errorMessage = text
    }
    
    func requestCreateOrderBooking(bankCode: String) {
        
        if self.advisorModel != nil {
            let data: [String: Any] = [
                "ClassificationIdList": self.selections, // list danh mục tư vấn - Là array - NOT NULL
                "AdviseType": self.selectionsAdviseType, // type ENUM -  hình thức tư vấn: Online, Offline -- NOT NULL
                "SessionList": ["Morning"], // Type ENUM -  buổi: Morning, Afternoon, Evening, AllDay
                "AdviseHours": self.hour, // số giờ tư vấn -- NOT NULL
                "AdvisorId": self.advisorModel.id, // Id advisor  -- NOT NULL,
                "StartDate": self.selectedDate.toString(format: .custom("yyyy/M/dd")),
                "EndDate": self.selectedDate.toString(format: .custom("yyyy/M/dd")),
                "StartHour": self.selectTime ?? "8:00", // Giờ bắt đầu
                "Note": self.note
            ]
            
            
            _ = service.postBookSchedule(parameters: data).done { response in
                if response.ok == false {
                    self.paymentFail = true
                } else {
                    //create payment VNPAY
                    if let data = response.payload
                    {
                        if let vnpTxnRef = data.vnpTxnRef
                        {
                            requestCreatePaymentVnpay(VnpTxnRef: vnpTxnRef, selectedBankCode: bankCode)
                        }
                    }
                }
            }
        }
        
        
    }
    
    func requestCreatePaymentVnpay(VnpTxnRef: String, selectedBankCode: String) {
        
        // OTP register
        let data: [String: Any] = [
            "OrderInfo": "Thanh toan dat lich",
            "VnpTxnRef": VnpTxnRef,
            "Type": 1, // đặt lịch
            "bankCode": selectedBankCode ?? "" // đặt lịch
        ]
        
        _ = service.postCreatePaymentVnPay(parameters: data).done { response in
            if response.message != "Success" {
                showAlert(text: "Có lỗi xảy ra, không thể tạo thanh toán")
            } else {
                //create payment VNPAY
                if let url = response.payload
                {
                    //                    if let selectedBankCode = self.selectedBankCode
                    //                    {
                    //                        self.urlAddress = url + "&vnp_BankCode=" + selectedBankCode
                    //                    } else
                    //                    {
                    //                        self.urlAddress = url
                    //                    }
                    self.urlAddress = url
                    self.isShowPaymentForm = true
                    self.isChooseBank = false
                }
            }
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

struct CalendarBookingReviewContentView: View {
    
    @Environment(\.calendar) var calendar
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack{
            CalendarWeekView(interval: self.year) { date in
                Text("30")
                    .hidden()
                    .padding(2)
                    .background((selectedDate ?? Date()).compare(.isSameDay(as: date)) ? Color(hex: "#E3F2FF") : .white) // Make your logic
                    .clipShape(Rectangle())
                    .cornerRadius(4)
                    .padding(2)
                    .overlay(
                        Text(String(self.calendar.component(.day, from: date))).appFont(style: .body, color: Color.black)
                    )
                    .onTapGesture {
                        self.selectedDate = date
                    }
            }
            
            Spacer()
        }.padding(.top, 20)
            .background(Color.white)
    }
    
}

struct AdvisorInfo: View {
    var favorite = false
    var item: AdvisorModel
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            if let item = item {
                HStack(alignment: .center, spacing: 15){
                    VStack(alignment: .center){
                        if let image = item.mediaUrl{
                            WebImage(url: URL(string: image))
                                .resizable()
                                .onSuccess { image, data, cacheType in
                                    // Success
                                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                }
                                .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                                .placeholder {
                                    Image("ic_picture_circle").resizable().scaledToFit()
                                }
                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            
                        }
                    }
                    VStack(alignment: .leading){
                        HStack{
                            if let advisorName = item.providerName {
                                Text("\(advisorName)").appFont(style: .body, weight: .bold, size: 13, color: Color(hex: "#4D4D4D")).fixedSize(horizontal: false, vertical: true)
                            }
                            //                            Spacer()
                            //                            if let rating = item.rating{
                            //                                StarsView(rating: Float(rating)).padding(0)
                            //                                Text("\(rating)").appFont(style: .body, weight: .regular, size: 8, color: .black)
                            //                            }
                        }
                        
                        HStack{
                            if let jobTitle = item.jobTitle{
                                Text("\(jobTitle)").appFont(style: .body, weight: .regular, size: 12, color: Color(hex: "#4D4D4D"))
                            }
                            
                        }
                        
                        
                        HStack{
                            HStack (alignment: .center, spacing: 0.0) {
                                Image( "ic_location")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.gray)
                                    .frame(width:6,height: 8).padding(.trailing,6)
                                if let city = item.city {
                                    Text("\(city)").appFont(style: .body, size: 10)
                                }else{
                                    Text("Hà nội").appFont(style: .body, size: 10)
                                }
                            }
                            
                            HStack (alignment: .center, spacing: 0.0) {
                                Image( "ic_dollar")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.gray)
                                    .frame(width:6,height: 8).padding(.trailing,6)
                                if let priceHours = item.priceHours{
                                    Text("\(priceHours)đ/h").appFont(style: .body, size: 10)
                                }
                            }
                            
                        }
                        if let list = item.classificationList
                        {
                            HStack {
                                ForEach(list) { item in
                                    Badge(text: item.name ?? "", textColorHex: "#fff", bgColorHex: "", textSize: 12.0)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            
            
            //            HStack (alignment: .top) {
            //                Button(action: {self.favorite = !favorite}, label:{
            //                    Image(systemName: favorite ? "heart.fill" : "heart").resizable()
            //                        .scaledToFit()
            //                        .foregroundColor(Color.gray)
            //                        .frame(width:17,height: 15).padding(.leading,0)
            //                }).offset(x: 0, y: 50)
            //            }
            
        }
        .padding(.horizontal, 18).padding(.vertical,17)
        .frame(width: screenWidth()-74)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
        
    }
}

struct ButtonSelectedCate: View {
    var item: ClassificationModel
    @Binding var selections: [Int]
    //    var action: () -> Void
    @State var isSelected = false
    
    var body: some View {
        Button(action: self.checkIsSelected) {
            Text(item.name ?? "")
                .myFont(style: .body, color: self.selections.contains(where: { $0 == item.id!}) ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
        }.buttonStyle(BorderButtonSelected(isSelected: self.selections.contains(where: { $0 == item.id!})))
        
    }
    
    func checkIsSelected() {
        if self.selections.contains(item.id!) {
            self.selections.removeAll(where: { $0 == item.id! })
        }
        else {
            self.selections.append(item.id!)
        }
        self.isSelected = self.selections.contains(where: { $0 == item.id!})
    }
}


struct ButtonSelectedType: View {
    var item: ButtonViewModel
    @Binding var selectionsAdviseType: String?
    //    var action: () -> Void
    @State var isSelected = false
    
    var body: some View {
        Button(action: self.checkIsSelected) {
            Text(item.name ?? "")
                .myFont(style: .body, color: item.id == selectionsAdviseType ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
        }.buttonStyle(BorderButtonSelected(isSelected: item.id == selectionsAdviseType))
        
    }
    
    func checkIsSelected() {
        self.selectionsAdviseType = item.id
    }
}

struct TimeViewSelect: View {
    var item: ButtonViewModel
    @Binding var selectTime: String?
    //    var action: () -> Void
    @State var isSelected = false
    
    var body: some View {
        Button(action: self.checkIsSelected) {
            Text(item.name ?? "")
                .myFont(style: .body, color: item.id == selectTime ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
        }.buttonStyle(BorderButtonTimeSelected(isSelected: item.id == selectTime))
        
    }
    
    func checkIsSelected() {
        self.selectTime = item.id
    }
}

struct PaymentScheduleReview_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScheduleReview(id: "258", selections: .constant([1])).previewDevice("iPhone 11 Pro").environmentObject(ProviderApiService()).environmentObject(BankListApiService())
    }
}
