//
//  RecentRowView.swift
//  WhatsApp Hero Animation (iOS)
//
//  Created by Balaji on 27/03/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecentRowView: View {
    
    @State var recent: NotificationItem
    @EnvironmentObject var service: UserApiService
        
    var body: some View {
        HStack(spacing: 15){
            
            // Making it as clickable Button....
            
            Button(action: {
 
            }, label: {
                
                ZStack {
                    if recent.title.contains("Rút tiền") {
                        Image("ic_money-1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                    } else if (recent.isSystem ?? false) {
                        Image("logo_system")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                    } else if let image = recent.mediaURL{
                        WebImage(url: URL(string: image))
                            .resizable()
                            .onSuccess { image, data, cacheType in
                                // Success
                                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                            }
                            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                            .placeholder {
                                Image("ic_picture_circle").resizable().scaledToFit().frame(width: 60, height: 60)
                            }
                            .indicator(.activity) // Activity Indicator
                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                   
                }
            })
            // it decreased the highlight color....
            .buttonStyle(PlainButtonStyle())
            
            VStack {
                VStack(alignment: .leading, spacing: 8, content: {
                    if let title = recent.title{
                        Text(title)
                            .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: (recent.isRead ?? false) ? "#808080" : "#4d4d4d"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let content = recent.content{
                        Text(content)
                            .appFont(style:.caption1)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                })
                
                Divider()
            }.padding(.top, 15)
        }
        .padding(.horizontal, 37)
        .background(Color(hex: (recent.isRead ?? false) ? "#fff" : "#f9f9f9"))
        .onTapGesture {
            _ = service.updateReadNotificationById(id:String(recent.announcementID ?? 0)).done({ CommonResponseModel in
                if CommonResponseModel.ok {
                    recent.isRead = true
                }
            })
        }
    }
}

struct RecentRowView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationViewPreview()
    }
}
