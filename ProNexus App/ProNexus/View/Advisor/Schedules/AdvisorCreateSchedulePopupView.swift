//
//  AdvisorCreateSchedule.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import SwiftUI
import SwiftyUserDefaults

struct AdvisorCreateSchedulePopupView: View {
    
    @Binding var show: Bool
    @State var selections: [String] = []
    @State var selectedDate: Date = Date()
    @State var isAllDay = false
    
    @EnvironmentObject var service: ProviderApiService
    
    @State var isShowAlertError = false
    @State var message = ""
    @State var list: [ScheduleEmptyModel]?
    var editMode = false
    var ScheduleProviderId: String?
    
    //Morning, Afternoon, Evening, AllDay
    @State var items: [ListMomentScheduleViewModel] = [
        ListMomentScheduleViewModel(id: "Morning", name: "Buổi sáng"),
        ListMomentScheduleViewModel(id: "Afternoon", name: "Buổi chiều"),
        ListMomentScheduleViewModel(id: "Evening", name: "Buổi tối"),
        ListMomentScheduleViewModel(id: "AllDay", name: "Cả ngày"),
    ]
    
    @State var scheduleProviderSessionList: [ScheduleProviderSessionList]? // phục vụ edit
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .center, spacing: 15, content: {
                
                VStack(alignment: .leading) {
                    if editMode {
                        ZStack {
                            Text("Sửa lịch trống")
                                .appFont(style: .headline, weight: .bold, size: 20, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .center)
                        }
                    } else
                    {
                        ZStack {
                            Text("Tạo lịch trống")
                                .appFont(style: .headline, weight: .bold, size: 20, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .center)
                            Button(action: {
                                // closing popup...
                                show.toggle()
                            }, label: {
                                Image(systemName: "xmark").resizable().frame(width: 10, height: 10).foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 15)
                            })
                        }
                    }
                    
                    
                    Divider().padding(.horizontal, 15)
                    
                    Text("Chọn ngày")
                        .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 15)
                    
                    CalendarAdvisorCreateScheduleView( selected: $selectedDate, list: $list)
                    
                    Text("Chọn lịch trống")
                        .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 15)
                    
                    VStack {
                        GridStack(minCellWidth: 100, spacing: 10, numItems: items.count) { index, cellWidth in
//                            ButtonSelectMoment(item: items[index], selections: $selections)
                            let item = items[index]
                            Button(action: {
                                if item.id == "AllDay" {
                                    self.selections.removeAll()
                                    self.selections.append(item.id!)
                                } else
                                {
                                    self.selections.removeAll(where: { $0 == "AllDay" })
                                    
                                    if self.selections.contains(item.id!) {
                                        self.selections.removeAll(where: { $0 == item.id! })
                                    }
                                    else {
                                        self.selections.append(item.id!)
                                    }
                                }
                            }) {
                                Text(item.name ?? "")
                                    .myFont(style: .body, color: self.selections.contains(where: { $0 == item.id!}) ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
                            }.buttonStyle(BorderButtonSelected(isSelected: self.selections.contains(where: { $0 == item.id!})))
                              
                        }
                    }.frame(height: 100)
                }
                
                Divider()
                VStack (alignment: .center) {
                    Button("Xác nhận") {
                        if editMode {
                            requestEditSchedule()
                        } else
                        {
                            requestCreateSchedule()
                        }
                        
                    }
                    .buttonStyle(BlueButton())
                    
                    Button("Huỷ Bỏ") {
                        self.show.toggle()
                    }.buttonStyle(ButtonLinkStyle())
                }
                
            })
            
            // show alert if have an error
//            if $isShowAlertError.wrappedValue {
//
//                AlertView(msg: message, show: $isShowAlertError)
//            }
        }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 25)
        
        // background dim...
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                loadData()
            }
    }
    
    func requestCreateSchedule() -> Void {
                
        // trường hợp allday thì remove key all day đi
        if self.selections.contains("AllDay") {
            self.selections.removeAll(where: { $0 == "AllDay" })
        }
        
        if self.selections.count == 0 {
            AppUtils.showAlert(text: "Vui lòng chọn khung thời gian")
            
        } else
        {
            let data: [String: Any] = [
                "StartDate": self.selectedDate.toString(format: .custom("yyyy/M/dd")),
                "EndDate": self.selectedDate.toString(format: .custom("yyyy/M/dd")),
                "Description": "",
                "SessionList": self.selections //
            ]

            _ = service.postAdvisorCreateSchedule(parameters: data).done { response in
                if (response.message == "Failure or Schedule Exist"){
                    AppUtils.showAlert(text: "Lịch đã tồn tại")
                } else if response.ok ?? false {
                    self.loadData()
                    AppUtils.showAlert(text: "Thêm lịch trống thành công")
                } else {
                    AppUtils.showAlert(text: "Không thể thêm lịch trống")
                }
            }
        }
        
        
    }
    
    func requestEditSchedule() -> Void {
        
        if self.selections.count == 0 {
            AppUtils.showAlert(text: "Vui lòng chọn khung thời gian")
            
        } else
        {

            var session : [String] = []
            // trường hợp allday thì remove key all day đi
            if self.selections.contains("AllDay") {
                session = ["Morning","Afternoon", "Evening"]
            } else
            {
                session = self.selections
            }
            
            let data: [String: Any] = [
                "StartDate": self.selectedDate.toString(format: .custom("yyyy/M/dd")),
                "EndDate": self.selectedDate.toString(format: .custom("yyyy/M/dd")),
                "Description": "",
                "SessionList": session //
            ]

            _ = service.postAdvisorEditSchedule(id: self.ScheduleProviderId!, parameters: data).done { response in
                if (response.message == "Failure or Schedule Exist"){
                    AppUtils.showAlert(text: "Lịch đã tồn tại")
                } else if response.ok ?? false {
                    self.loadData()
                    AppUtils.showAlert(text: "Sửa lịch trống thành công")
                } else {
                    AppUtils.showAlert(text: "Không thể Sửa lịch trống")
                }
//                loadData()
            }
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
}


struct CalendarAdvisorCreateScheduleView: View {
    
    @Environment(\.calendar) var calendar
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    @ObservedObject var service: ProviderApiService = ProviderApiService()
    @Binding var selected: Date
    @Binding var list: [ScheduleEmptyModel]?
    
    
    var body: some View {
        VStack{
            CalendarView(interval: self.year) { date in
//                Text(String(self.calendar.component(.day, from: date)))
                Text("30")
                    .hidden()
                    .padding(4)
                    .background(checkSelected(date: date) ? Color(hex: "#E3F2FF") : .white) // Make your logic
                    .clipShape(Rectangle())
                    .cornerRadius(4)
                    .frame(width: 26, height: 16)
                    .padding(2)
                    .appFont(style: .body)
                    .overlay(
                        Text(String(self.calendar.component(.day, from: date))).appFont(style: .body, color: checkValidDateRange(today: date) ? Color(hex: "#1D74FE") : Color.black)
                    )
                    .onTapGesture {
                        selected = date
                    }
            }
        }.padding(.vertical, 20)
    }
    
    func checkSelected(date: Date) -> Bool {
        return date.compare(.isSameDay(as: selected))
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


//struct AdvisorCreateSchedule_Previews: PreviewProvider {
//    static var previews: some View {
//        AdvisorCreateSchedulePopupView(show: true).environmentObject(ProviderApiService())
//    }
//}
