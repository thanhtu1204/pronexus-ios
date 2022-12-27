//
//  ProfileFrame.swift
//  ProNexus
//
//  Created by TUYEN on 11/14/21.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftyUserDefaults

struct ProfileFrame: View {
    
    var info: ScheduleCustomerModel
    
    @State var navToChatMessage = false
    @State var chatDocId: String?
    
    @ObservedObject var chatModel = ChatroomsViewModel()
    
    var body: some View {
        VStack (){
            HStack (spacing: 10) {
                if isAdvisorRole()
                {
                    // server chưa trả về
                    if let image = info.customerMediaUrl {
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
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    }
                }
                
                if isUserRole()
                {
                    if let image = info.advisorMediaUrl {
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
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    }
                }
                
                VStack (alignment: .leading, spacing: 15) {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 3){
                            if isAdvisorRole()
                            {
                                Text(info.customerName ?? "").bold(size: 14).multilineTextAlignment(.leading)
                            }
                            
                            if isUserRole()
                            {
                                Text(info.advisorName ?? "").regular(size: 14).multilineTextAlignment(.leading)
                            }
                            
                            Text(info.jobTitle ?? "").appFont(style: .body, size: 12)
                        }
                        .frame(width: 150, alignment: .leading)
                        Button {
                            self.navChatDetail()
                        } label: {
                            Image("ic_chat_circle").resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        }
//                        .background(Color.red)

                    }
                    
                    HStack () {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color(hex: "#808080"))
                        
                        if isAdvisorRole()
                        {
                            Text(info.customerProvince ?? "").appFont(style: .title1, size: 10, color: Color(hex: "#808080"))
                        }
                        
                        if isUserRole()
                        {
                         
                            Text(info.advisorProvince ?? "").appFont(style: .title1, size: 10, color: Color(hex: "#808080"))
                            
                            HStack{ Divider()}.frame( height: 15)
                            
                            Image(systemName: "dollarsign.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color(hex: "#808080"))
                            Text(String(info.price ?? 0).convertDoubleToCurrency()).appFont(style: .title1, size: 10, color: Color(hex: "#808080"))
                            
                            HStack{ Divider()}.frame( height: 15)
                            
                            Text(String(info.advisorAvgRate().round(to: 1))).appFont(style: .title1, size: 10, color: Color(hex: "#808080"))
                            
                            Image(systemName: "star.fill").resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color(hex: "#FFC700"))
                        }
                    }
                }
              
            }.padding(.horizontal, 15)
            
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
        }
        .frame(width: UIScreen.screenWidth - 74, height: 115)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
    }
    
    func navChatDetail() {
        if let user = Defaults.userLogger {
            DispatchQueue.main.async {
                let customerId = info.customerID ?? 0
                let advisorId = info.advisorID ?? 0
                //customer role
                chatModel.createChatroom(
                                         fromUserId: String(customerId),
                                         fromUserName: info.customerName ?? "",
                                         fromUserAvatar: info.customerMediaUrl ?? "",
                                         toUserName: info.advisorName ?? "",
                                         toUserId: String(advisorId),
                                         toUserAvatar: info.advisorMediaUrl ?? "",
                                         handler: { docId in
                    self.chatDocId = docId
                    self.navToChatMessage = true
                })
            }
        }
    }
}

//struct CustomProfileFrame: View {
//    @State var isShowAlertError = true
//    var body: some View {
//        if $isShowAlertError.wrappedValue {
//            ProfileFrame(firstName: "Dang Van", lastName: "Tuyen", image_url: "button1", price: "300.000", jobTitle: "Cố vấn tài chính", address: "Hà Nội", rate: "4.9")
//        }
//    }
//}
//
//struct ProfileFrame_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomProfileFrame()
//    }
//}
