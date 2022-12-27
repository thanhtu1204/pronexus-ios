//
//  MyDatePicker.swift
//  ProNexus
//
//  Created by thanh cto on 22/11/2021.
//

import SwiftUI

struct MyDatePicker: View {
    var title: String = "Chọn thời gian"
    @Binding var show: Bool
    @Binding var dateString: String
    @State var date: Date = Date()
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15, content: {
            Text(title).appFont(style: .title1)
            
            DatePicker("", selection: $date.onUpdate {
                self.dateString = date.toString(format: .custom("dd/M/yyyy"))
            }, displayedComponents: .date).datePickerStyle(WheelDatePickerStyle())
            
            Button(action: {
                // closing popup...
                show.toggle()
            }, label: {
                Text("Đóng")
                    .appFont(style: .body)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
//                    .background(Color(hex: "#f2f2f2"))
                    .cornerRadius(15)
            })
            
            // centering the button
            .frame(alignment: .center)
        })
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal, 50)
        
        // background dim...
        .frame(maxWidth: screenWidth(), maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }
}

//struct MyDatePickerContentView: View {
//    @State var isShow = true
//    @State var dateString: String = ""
//    var body: some View {
//        if $isShow.wrappedValue {
//            MyDatePicker(show: $isShow, dateString: $dateString)
//        }
//    }
//}


//struct MyDatePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        MyDatePickerContentView()
//    }
//}
