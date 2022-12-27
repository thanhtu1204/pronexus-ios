//
//  RowSectionAppointment.swift
//  ProNexus
//
//  Created by Tú Dev app on 03/11/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
struct RowSectionAppointment: View {
    var item : ScheduleCustomerModel
    var body: some View {
        VStack{
            HStack{
                Text(AppUtils.translateAppointmentOrderStatus(text: item.scheduleType ?? "")).font(.system(size: 12))
                    .padding(.horizontal, 10)
                    .background(Color(hex:"#FFB300"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                Text("\(item.adviseHours!) giờ").font(.system(size: 12))
                    .padding(.horizontal, 10)
                    .background(Color(hex: "#999999"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                Spacer()
                //                Button(action: {}) {
                //                    HStack {
                //                        Image("ic_more")
                //                    }
                //                    .padding(.all, 8.0)
                //                    .frame(width: 14, height: 14)
                //                    .background(Color("button"))
                
                //                }
            }.padding(.vertical,2)
            HStack {
                if let image = item.mediaURL{
                    WebImage(url: URL(string: image))
                        .resizable()
                        .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                        .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                        .placeholder {
                            Image("ic_picture_circle")
                        }
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                }
                VStack (alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(item.firstName!) \(item.lastName!)")
                            .font(.system(size:14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "#808080"))
                    }.padding(.trailing,10)
                    
                    if let classificationList = item.classificationList{
                        
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(classificationList){item in
                                    Text(item.name!)
                                        .regular(size: 12, color: Color(hex: "#808080"))
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
                Spacer()
            }.frame(width:230,height: 50).padding(.vertical,2).padding(.leading,20)
            Divider()
            
            VStack () {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(height: 10)
                    if let startDate = item.startDate{
                        Text("\((Date(fromString: startDate[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy")))!)").appFont(style: .body, size: 10)
                    }
                    Spacer()
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(height: 10)
                    if let startHour = item.startHour{
                        Text("\(buildTime(startHour: startHour, offset: item.adviseHours ?? 0))").appFont(style: .body, size: 10)
                    }
                    
                }
                
            }.padding(.horizontal, 0)
            
            
        }.padding().frame(width:230,height: 116)
            .background(Color(hex: "#FFFFFF"))
            .cornerRadius(15.0)
            .myShadow()
        
    }
    
    func buildTime(startHour: String, offset: Int) -> String
    {
        return "\((Date(fromString: "16 July 1972 \(startHour):00", format: .custom("dd MMM yyyy HH:mm:ss"))?.toString(format: .custom("HH:mm")))!) - \((Date(fromString: "16 July 1972 \(startHour):00", format: .custom("dd MMM yyyy HH:mm:ss"))?.adjust(.hour, offset: offset).toString(format: .custom("HH:mm")))!)"
    }
    
}

struct RowSectionAppointment_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}
