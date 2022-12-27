//
//  ItemConfirm.swift
//  ProNexus
//
//  Created by Tú Dev app on 02/11/2021.
//


import SwiftUI
import SDWebImageSwiftUI
struct ItemConfirm: View {
    var item : ScheduleCustomerModel
    var body: some View {
        HStack {
            VStack(alignment: .center){
                if let image = item.mediaURL{
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
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            }
            VStack (alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(item.firstName!) \(item.lastName!)")
                        .font(.system(size:14))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#808080"))
                    Spacer()
//                    Text("hot").font(.system(size: 12))
//                        .padding(.horizontal, 10)
//                        .background(Color(hex: "#FF0000"))
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
                    
                    
                }.padding(.trailing,10)
                
                
                if let classificationList = item.classificationList{
                    
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(classificationList){item in
                                        Text(item.name!)
                                            .font(.system(size:12))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color(hex: "#808080"))
                                
                            }
                        }
                    
                    }
                    
                }
                
                HStack () {
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
                        Text(buildTime(startHour: startHour, offset: item.adviseHours ?? 0)).appFont(style: .body, size: 10)
                    }
                    
                    
                }.padding(.horizontal, 0)
            }
            .frame(width: screenWidth() / 2)
        }
        .padding()
        .frame(width:280,height: 76)
        .background(Color(hex: "#FFFFFF"))
        .cornerRadius(15.0)
        .myShadow()
        
    }
    
    func buildTime(startHour: String, offset: Int) -> String
    {
        return "\((Date(fromString: "16 July 1972 \(startHour):00", format: .custom("dd MMM yyyy HH:mm:ss"))?.toString(format: .custom("HH:mm")))!) - \((Date(fromString: "16 July 1972 \(startHour):00", format: .custom("dd MMM yyyy HH:mm:ss"))?.adjust(.hour, offset: offset).toString(format: .custom("HH:mm")))!)"
    }
}
struct ItemConfirm_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}
