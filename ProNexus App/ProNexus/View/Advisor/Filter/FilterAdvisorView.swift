//
//  FilterAdvisorView.swift
//  ProNexus
//
//  Created by Tú Dev app on 14/11/2021.
//

import SwiftUI
import WrappingHStack
// Tab Model...
struct Item: Identifiable {
    var id = UUID().uuidString
    var name : String
}

var rateItems = [
    
    Item(id: "1", name: "Từ 1"),
    Item(id: "2", name: "Từ 2"),
    Item(id: "3", name: "Từ 3"),
    Item(id: "4", name: "Từ 4"),
    Item(id: "5", name: "Từ 5"),
]

var priceItems = [
    Item(id: "200", name: "Từ 200k"),
    Item(id: "500", name: "Từ 500k"),
    Item(id: "1000", name: "Từ 1000k"),
]



struct FilterAdvisorView: View {
    
    @State var results: [ClassificationModel] = []
    @EnvironmentObject var service: ClassificationApiService
    @EnvironmentObject var serviceAdvisor: ProviderApiService
    @Environment(\.presentationMode) private var presentationMode
    
    @Environment(\.calendar) var calendar
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    @Binding var show: Bool
    @Binding var provinceId: Int?
    @Binding var isSelectedStar:String
    @Binding var isSelectedPrice:String
    @Binding var selections: [Int]
    
    @State var provinceName = ""
    @State var loading = true
    @State var isSelected = false
    @State var onChangeProvince = false
    @State var showProvinceModal = false
    @State var city:String = ""
    @State var selectedDate: Date = Date()
    @State var starSelections : [String] = []
    
    static var uniqueKey: String {
        UUID().uuidString
    }
    
    var body: some View {
        ZStack () {
            VStack{
                ScrollView (.vertical, showsIndicators: false) {
                    VStack{
                        Text("Chuyên môn")
                            .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                        
                        if $loading.wrappedValue {
                            SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                        }else {
                            if let list = self.results
                            {
                                WrappingHStack(list) { item in
                                    ButtonSelectedCate(item: item, selections: $selections).padding(.bottom, 6)
                                }
                            }
                            else
                            {
                                NoData()
                            }
                        }
                    }.padding(.top, 30)
                    
                    
                    VStack{
                        Text("Đánh giá")
                            .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                        VStack{
                            if let list = rateItems
                            {
                                //                        ScrollView(.horizontal, showsIndicators: false)
                                //                        {
                                //                            HStack (alignment: .firstTextBaseline) {
                                //                                ForEach(list) { item in
                                //                                    Button(action: {
                                //                                        self.isSelectedStar = item.id
                                //                                    }) {
                                //                                        HStack{
                                //                                            Text(item.name)
                                //                                                .myFont(style: .body, color: isSelectedStar == item.id ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
                                //                                            Image(systemName: "star.fill").resizable().frame(width: 10, height: 10).foregroundColor(Color(hex: "#FFC700"))
                                //                                        }
                                //                                    }.buttonStyle(BorderButtonSelected(isSelected:  isSelectedStar == item.id)).padding(.vertical,5)
                                //                                }
                                //                            }
                                //                        }
                                WrappingHStack(list) { item in
                                    Button(action: {
                                        self.isSelectedStar = item.id
                                    }) {
                                        HStack{
                                            Text(item.name)
                                                .myFont(style: .body, color: isSelectedStar == item.id ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
                                            Image(systemName: "star.fill").resizable().frame(width: 10, height: 10).foregroundColor(Color(hex: "#FFC700"))
                                        }
                                    }.buttonStyle(BorderButtonSelected(isSelected:  isSelectedStar == item.id)).padding(.vertical, 5)
                                }
                            }
                        }
                    }
                    
                    VStack{
                        Text("Phí tư vấn")
                            .appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                        VStack{
                            if let list = priceItems
                            {
                                //                        ScrollView(.horizontal, showsIndicators: false)
                                //                        {
                                //                            HStack (alignment: .firstTextBaseline) {
                                //                                ForEach(list) { item in
                                //                                    Button(action: {
                                //                                        self.isSelectedPrice = item.id
                                //                                    }) {
                                //                                        HStack{
                                //                                            Text(item.name)
                                //                                                .myFont(style: .body, color: isSelectedPrice == item.id ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
                                //
                                //                                        }
                                //                                    }.buttonStyle(BorderButtonSelected(isSelected:  isSelectedPrice == item.id)).padding(.vertical,5)
                                //                                }
                                //                            }
                                //                        }
                                
                                WrappingHStack(list) { item in
                                    Button(action: {
                                        self.isSelectedPrice = item.id
                                    }) {
                                        HStack{
                                            Text(item.name)
                                                .myFont(style: .body, color: isSelectedPrice == item.id ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
                                            
                                        }
                                    }.buttonStyle(BorderButtonSelected(isSelected:  isSelectedPrice == item.id)).padding(.vertical,5)
                                }
                            }
                        }
                    }
                    VStack{
                        Text("Lịch trống")
                            .appFont(style: .body,weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                        //                    CalendarAdvisorCreateScheduleView( selected: $selectedDate)
                        
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
                                        Text(String(self.calendar.component(.day, from: date))).appFont(style: .body, color: Color(hex: "#333"))
                                        //                                    Text(String(self.calendar.component(.day, from: date))).appFont(style: .body, color: checkValidDateRange(today: date) ? Color(hex: "#1D74FE") : Color.black)
                                    )
                                    .onTapGesture {
                                        self.selectedDate = date
                                    }
                            }
                        }.padding(.vertical, 10)
                        
                    }
                    VStack (spacing: 0) {
                        Text("Địa điểm")
                            .appFont(style: .body,weight: .bold, size: 14, color: Color(hex: "#4D4D4D")).frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack (alignment: .leading) {
                            MyTextField(placeholder: "Tỉnh/Thành phố", value: $provinceName, required: false, readOnly: true)
                        }
                        .padding(.vertical, 20)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showProvinceModal.toggle()
                        }

                        VStack{
                            Button(
                                action: {
//                                    if self.selections.count > 0{
//                                        let type = joinArray(data: self.selections)
//                                        _ = serviceAdvisor.loadListAdvisor(type:type, selectedRating: isSelectedStar, priceHour: isSelectedPrice, provinceId: provinceId ?? 0)
//                                    } else{
//                                        _ = serviceAdvisor.loadListAdvisor(selectedRating: isSelectedStar, priceHour: isSelectedPrice, provinceId: provinceId ?? 0)
//                                    }
                                    self.show.toggle()
                                },
                                label: { Text("Tìm cố vấn") }
                            ).buttonStyle(BlueButton())
                            
                            Button {
                                self.provinceName = ""
                                self.city = ""
                                self.isSelectedStar = ""
                                self.isSelectedPrice = ""
                                self.selections = []
                                self.starSelections = []
                                self.show.toggle()
                                
                            } label: {
                                Text("Đặt lại")
                                    .appFont(style: .body,weight: .regular, size: 16, color: Color(hex: "#4C99F8")).frame(maxWidth: .infinity, alignment: .center)
                            }

                        }.padding(.bottom, 50)
                    }
                    
                    Spacer()
                }
            }.padding(.horizontal, 30)
                .onAppear {
                    self.loading = true
                    _ = service.loadClassificationList().done { ClassificationListModel in
                        if let items = ClassificationListModel.results {
                            self.results = items
                        }
                        self.loading = false
                    }
                }
            
            if $showProvinceModal.wrappedValue {
                ProvinceModalView(show: $showProvinceModal, provinceId: $provinceId, provinceName: $provinceName,  onChangeProvince: $onChangeProvince ).environmentObject(ProviderApiService())
                    .edgesIgnoringSafeArea(.all)
            }
            
        }
    }
    
    func joinArray(data :[Int]) -> String {
        let array = data
        let stringArray = array.map { String($0) }
        let string = stringArray.joined(separator: ",")
        return string
    }
}


struct MultipleSelectionButtonCate: View {
    var item: ClassificationModel
    var isSelected: Bool
    var w: CGFloat
    var h: CGFloat
    var action: () -> Void
    
    var body: some View {
        VStack(alignment:.center){
            Button(action: self.action) {
                Text(item.name ?? "")
                    .myFont(style: .body, color: self.isSelected ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
            }
            
        }.padding(.all, 5.1)
            .frame(width: w, height: h)
            .buttonStyle(BorderButtonSelected(isSelected: self.isSelected))
    }
}

struct MultipleSelectionButtonStar: View {
    var item: ClassificationModel
    var isSelected: Bool
    var w: CGFloat
    var h: CGFloat
    var action: () -> Void
    
    var body: some View {
        VStack(alignment:.center){
            Button(action: self.action) {
                Text(item.name ?? "")
                    .myFont(style: .body, color: self.isSelected ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
                
            }
            
        }.padding(.all, 5.1)
            .frame(width: w, height: h)
            .buttonStyle(BorderButtonSelected(isSelected: self.isSelected))
    }
}

//struct FilterAdvisorView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterAdvisorView(show: .constant(true)).environmentObject(ProviderApiService()).environmentObject(ClassificationApiService())
//    }
//}
