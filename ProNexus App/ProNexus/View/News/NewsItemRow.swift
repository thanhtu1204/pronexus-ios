//
//  NewsItemRow.swift
//  ProNexus
//
//  Created by thanh cto on 01/11/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct NewsItemRowView: View {
    var item: NewsModel
    @State var desText: String = ""
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8){
            
            WebImage(url: URL(string: item.postThumbnail!)!)
                .resizable()
                .frame(width: 249, height: 114)
                .scaledToFit()
            
//            Spacer()
            HStack (alignment: .center, spacing: 0.0) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.gray)
                    .frame(height: 18)
                
                if let authorName = item.authorName {
                    Text("  \(authorName)").appFont(style: .body, size: 10)
                }
                
                
                Spacer()
                
                Image(systemName: "eye")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.gray)
                    .frame(height: 10)
                
                Text("  \(item.viewCount ?? 0)").appFont(style: .body, size: 10)
                
                Spacer()
                
                if let createdAt = item.createdAt {
                    
                    
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(height: 10)
                    Text("  \((Date(fromString: createdAt[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy")))!)").appFont(style: .body, size: 10)
                }
            }
            .padding(.horizontal, 15.0)
            
            
            VStack(alignment: .leading, spacing: 8) {
                if let title = item.title {
                    Text(title).appFont(style: .title1).lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                if let des = item.description {
                    Text(des.htmlStripped).appFont(style: .body, size: 10).lineLimit(1)
                }
            }
            .padding(.horizontal, 15.0)
            Spacer()
        }
        .frame(width: screenWidth() / 1.5,height: 227)
        .background(Color.white)
        .cornerRadius(15)
        .myShadow()
    }
    
//    func htmlToText(html: String) {
//        DispatchQueue.global(qos: .default).async {
//            DispatchQueue.main.async {
//                self.desText = html.htmlToString
//            }
//
//        }
//    }
}

struct NewsItemRowView_Previews: PreviewProvider {
    static var previews: some View {
//        NewsHomeView().environmentObject(NewsApiService())
        HomeView().environmentObject(UserApiService()).environmentObject(ProviderApiService())
    }
}
