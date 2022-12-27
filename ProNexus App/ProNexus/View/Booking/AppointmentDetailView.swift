//
//  AppointmentDetailView.swift
//  ProNexus
//
//  Created by IMAC on 11/2/21.
//

import Foundation
import Combine
import SwiftUI
import SDWebImageSwiftUI
import SwiftyUserDefaults

struct AppointmentDetailView: View {
    
    @State var id: Int
    @State var expand = false
    @State private var sort: Int = 0
    
    @State var item : ScheduleCustomerModel?
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.isPreview) var isPreview
    @EnvironmentObject var service: ProviderApiService
    
    
    @State var message = ""
    @State var isShowStop = false
    @State var isShowStart = false
    @State var isShowCancel = false
    @State var isShowDelete = false
    @State var isShowConfirm = false
    @State var isShowAlertError = false
    
    @State var loading = true
    
    let pd = (UIScreen.screenWidth - 100) / 2
    
    var body: some View {
        NavigationView {
        VStack {
            
            ZStack(alignment: .top) {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        // HEADER                        
                        Header(title: "Thông tin lịch hẹn", contentView: {
                            ButtonIcon(name: "arrow.left", onTapButton: {
                                self.presentationMode.wrappedValue.dismiss()
                                
                            })
                            Spacer()
                            Button {
                                self.expand.toggle()
                            } label: {
                                Image("ic_more_white")
                            }
                        })
                        
                        VStack {
                            if expand {
                                VStack(alignment: .center){
                                    Text("Sửa").appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080")).onTapGesture {
                                        //                          selectCatName = "Sửa"
                                        self.expand.toggle()
                                    }.padding(.top, 5)
                                    //                                Divider()
                                    //                                Button("Xoá") {
                                    ////                                            isShowDelete = true
                                    //                                }
                                        .onTapGesture {
                                            //                          selectCatName = "Sửa"
                                            self.expand.toggle()
                                        }.padding(.bottom, 5)
                                        .appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080"))
                                }
                                .padding(.horizontal, 4)
                                .background(Color.white)
                                .frame(width: 70, alignment: .center)
                                .cornerRadius(8)
                                .padding(.trailing, 37)
                                .myShadow()
                                
                            }
                        }
                        .frame(width: 70, height: 40, alignment: .trailing)
                        .zIndex(999)
                    }.zIndex(999)
                    
                    if $loading.wrappedValue {
                        SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                    } else
                    {
                        if let item = item {
                            let totalPrice = Double((item.adviseHours ?? 0) * (item.price ?? 0))
                            ScrollView () {
                                
                                VStack() {
                                    ProfileFrame(info: item)
                                    
                                    VStack (alignment: .leading, spacing: 15){
                                        HStack (alignment: .center) {
                                            Text("Thông tin lịch hẹn").appFont(style: .title1)
                                                .frame(width: pd,  alignment: .leading )
                                            Spacer()
                                            Badge(text: AppUtils.translateAppointmentOrderStatus(text: item.scheduleType ?? ""), textColorHex: "#fff", bgColorHex: "#50A0FC")
                                                .frame(width: pd,  alignment: .leading )
                                        }
                                        
                                        .padding(.vertical, 20)
                                        .padding(.leading, 60)
                                        HStack (alignment: .center) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Lĩnh vực").appFont(style: .title1, size: 12, color: Color(hex: "#808080"))
                                                if let classificationList = item.classificationList{
                                                    ForEach(classificationList){item in
                                                        Text(item.name ?? "")
                                                            .appFont(style: .title1, size: 12)
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            .frame(width: pd,  alignment: .leading )
                                            Spacer()
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Hình thức").appFont(style: .title1, size: 12, color: Color(hex: "#808080"))
                                                Text(item.adviseType ?? "").appFont(style: .title1, size: 12)
                                            }
                                            .frame(width: pd,  alignment: .leading )
                                        }
                                        .padding(.leading, 60)
                                        Divider()
                                        HStack (alignment: .center) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Thời gian").appFont(style: .title1, size: 12, color: Color(hex: "#808080"))
                                                if let startDate = item.startDate{
                                                    Text("\((Date(fromString: startDate[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy")))!)").appFont(style: .title1, size: 12)
                                                }
                                            }
                                            .frame(width: pd,  alignment: .leading )
                                            Spacer()
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Số giờ tư vấn").appFont(style: .title1, size: 12, color: Color(hex: "#808080"))
                                                Text("\(item.adviseHours ?? 0) giờ").appFont(style: .title1, size: 12)
                                            }
                                            .frame(width: pd,  alignment: .leading )
                                        }
                                        .padding(.leading, 60)
                                        Divider()
                                        HStack (alignment: .firstTextBaseline) {
                                            Text("Tổng chi phí tư vấn").appFont(style: .title1, size: 12, color: Color(hex: "#808080"))
                                                .frame(width: pd,  alignment: .leading )
                                            Spacer()
                                            Text(String(totalPrice).convertDoubleToCurrency()).appFont(style: .title1, size: 12)
                                                .frame(width: pd,  alignment: .leading )
                                        }
                                        .padding(.leading, 60)
                                        
                                        Text("Ghi chú: \(item.note ?? "")")
                                            .appFont(style: .body, size: 12, color: Color(hex: "#808080"))
                                            .padding(.leading, 60)
                                        Divider()
                                    }
                                    .frame(width: UIScreen.screenWidth - 74)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .myShadow()
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 5)
                                    
                                    
                                }
                                .padding(.top, 50)
                                
                                //                        Pending - Chờ xác nhận sau khi đã thành công
                                //                        Approve - Trạng thái xác nhận cuộc hẹn
                                //                        Progressing - Đang diễn ra, user bấm bắt đầu  ( update ngày giờ )
                                //                        Done - Khi user kết thúc ( update ngày giờ kết thúc)
                                //                        Cancel - Khi advisor bấm từ chối
                                
                                VStack {
                                    if let user = Defaults.userLogger
                                    {
                                        
                                        if user.role == UserRole.advisor.rawValue {
                                            if (item.scheduleType == AppointmentStatus.Pending.rawValue){
                                                Button("Xác nhận lịch hẹn") {
                                                    isShowConfirm = true
                                                }
                                                .buttonStyle(GreenButton())
                                                
                                                Button("Từ chối") {
                                                    isShowCancel = true
                                                }
                                                .buttonStyle(SilverButton())
                                                .padding(.top, 5)
                                            }
                                        } else
                                        {
                                            if (item.scheduleType == AppointmentStatus.InProgress.rawValue) {
                                                Button("Kết thúc") {
                                                    isShowStop =  true
                                                }
                                                .buttonStyle(RedButton())
                                                
                                            }
                                            
                                            // can doi advisor approved moi bat dau dc
                                            if (item.scheduleType == AppointmentStatus.Approve.rawValue) {
                                                Button("Bắt đầu") {
                                                    isShowStart =  true
                                                    // chuyển trạng thái sang inprogress
                                                }
                                                .buttonStyle(GreenButton())
                                                
                                            }
                                            
                                            if (item.scheduleType == AppointmentStatus.Done.rawValue) {
                                                HStack{
                                                    NavigationLink {
                                                        AdvisorDetailView(id: "\(item.advisorID ?? 0)").navigationBarHidden(true).navigationBarBackButtonHidden(true)
                                                    } label: {
                                                        Text("Mua lại").appFont(style: .body, color: Color(hex: "#4C99F8"))
                                                    }.buttonStyle(BlueButtonBorder(w: 140))
                                                    
                                                    Spacer()
                                                    
                                                    NavigationLink {
                                                        AdvisorReviewsView(providerId : item.advisorID ?? 0, imgURL: item.advisorMediaUrl ?? "", fullName: item.advisorName ?? "", jobTitle: item.jobTitle ?? "").environmentObject(ProviderApiService())
                                                            .navigationBarBackButtonHidden(true)
                                                            .navigationBarHidden(true)
                                                    } label: {
                                                        HStack{
                                                            Text("Đánh giá").myFont(style: .body, color: Color(hex: "#FFFFFF") )
                                                        }
                                                        
                                                    }.buttonStyle(YellowButton(w: 140))
                                                    
                                                }.frame(width: containerWidth())
                                            }
                                            
                                        }
                                    }
                                    
                                }.padding(.top, 20)
                                    .padding(.top, 20)
                            }
                        }
                        else
                        {
                            NoData()
                        }
                    }
                    
                    Spacer()
                    
                }
                if $isShowAlertError.wrappedValue {
                    
                    AlertView(msg: message, show: $isShowAlertError)
                }
                
                if $isShowConfirm.wrappedValue {
                    CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn xác nhận cuộc hẹn?", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {onConfirmChangeStatus()}, onPressBtn2: {}, show: $isShowConfirm)
                }
                if $isShowCancel.wrappedValue {
                    CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn từ chối cuộc hẹn?", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {onCancelChangeStatus()}, onPressBtn2: {}, show: $isShowCancel)
                }
                if $isShowStart.wrappedValue {
                    CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn bắt đầu cuộc hẹn?", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {onStart()}, onPressBtn2: {}, show: $isShowStart)
                }
                if $isShowStop.wrappedValue {
                    CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn kết thúc cuộc hẹn?", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {onStop()}, onPressBtn2: {}, show: $isShowStop)
                }
                if $isShowDelete.wrappedValue {
                    CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn xoá cuộc hẹn?", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {onDelete()}, onPressBtn2: {}, show: $isShowDelete)
                }
            }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
            Spacer()
        }.onAppear() {
            
            loadData()
        }
    }
    }
    
    func loadData () {
        _ = service.loadCustomerScheduleById(id: self.id).done { rs in
            if let item = rs.data {
                self.item = item
            }
            self.loading = false
        }
    }
    
    func onConfirmChangeStatus(){
        requestChangeStatus(status: .Approve)
        isShowConfirm = false
        //        self.presentationMode.wrappedValue.dismiss()
    }
    
    func onCancelChangeStatus(){
        requestChangeStatus(status: .Cancel)
        isShowCancel = false
        //        self.presentationMode.wrappedValue.dismiss()
    }
    
    // 3. bắt đầu
    func onStart(){
        requestChangeStatus(status: .InProgress)
        isShowStart = false
        //        self.presentationMode.wrappedValue.dismiss()
    }
    // 4. kết thúc
    func onStop(){
        requestChangeStatus(status: .Done)
        isShowStop = false
        //        self.presentationMode.wrappedValue.dismiss()
    }
    
    func onDelete(){
        _ = service.deleteAppointment(id: "\(self.id ?? 0)" ).done { response in
            if response.ok {
                
            } else {
                self.message = "Xảy ra lỗi không thể xoá lịch hẹn"
                self.isShowAlertError = true
            }
        }
        isShowDelete = false
        //        self.presentationMode.wrappedValue.dismiss()
    }
    
    func requestChangeStatus(status: AppointmentStatus) {
        
        _ = service.changeStatusAppointment(id: self.id, status: status).done { response in
            if response.ok {
                self.loadData() // refresh api
            } else {
                self.message = "Xảy ra lỗi không thể cập nhật trạng thái"
                self.isShowAlertError = true
            }
        }
    }
    
    
}

struct AppointmentDetailViewContent: View {
    
    @State var item: ScheduleCustomerModel = ScheduleCustomerModel()
    
    let jsonData = """
{
      "ScheduleOrderId": 19,
      "AdviseType": "Online",
      "StartDate": "2021-11-10T00:00:00",
      "EndDate": "2021-11-10T00:00:00",
      "AdviseHours": 3,
      "AdvisorId": null,
      "FirstName": "Nguyễn Văn",
      "LastName": "Cẩm",
      "Phone": "0813201080",
      "Status": 2,
      "ScheduleType": "Pending",
      "ClassificationList": [
        {
          "ClassificationId": 1,
          "Name": "Hoạch định",
          "Description": "Chuyên gia hoạch định tài chính"
        },
        {
          "ClassificationId": 2,
          "Name": "Đầu tư",
          "Description": "Chuyên gia tư vấn đầu tư"
        }
      ],
      "SessionList": [
        "Evening"
      ],
      "CreatedDate": "2021-11-12T18:22:15.853",
      "UpdatedDate": "2021-11-12T18:22:15.853",
      "MediaUrl": "https://hinhanhdepvai.com/wp-content/uploads/2017/04/tai-anh-gai-xinh-de-thuong.jpg",
      "Note": "Đây là note",
      "Price": 200000.0,
      "StartHour": "9:30"
}
""".data(using: .utf8)
    
    var body: some View {
        AppointmentDetailView(id: 239).environmentObject(ProviderApiService()).onAppear {
            let rs: ScheduleCustomerModel = try! JSONDecoder().decode(ScheduleCustomerModel.self, from: jsonData!)
            self.item = rs
        }
    }
}

struct AppointmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentDetailViewContent().environmentObject(ProviderApiService())
    }
}
