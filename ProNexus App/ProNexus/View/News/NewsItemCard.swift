//
//  NewsItemCard.swift
//  ProNexus
//
//  Created by thanh cto on 02/11/2021.
//

import Foundation

import Foundation
import SwiftUI

struct NewsItemCardView: View {
    var item: NewsModel
    var body: some View {
        
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 10) {
                if let cate = item.category?.name {
                    Badge(text: cate, textColorHex: "#fff", bgColorHex: "#1D74FE")
                }
                
                if let title = item.title {
                    Text(title).appFont(style: .title1)
                        .appFont(style: .title1)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                if let des = item.description {
                    Text(des.htmlStripped).appFont(style: .body, size: 10)
                        .lineLimit(3)
                        .appFont(style: .title1)
                        .multilineTextAlignment(.leading)
                }
                
            }.padding(.all,15)
            
            Divider()
            
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
            }.padding([.leading, .bottom, .trailing], 15)
            
        }
        .padding(.top, 17.5)
        .frame(width: screenWidth() - (37 * 2))
        .background(Color.white)
//        .border(Color(hex: "#B3B3B3"), width: 1)
        .cornerRadius(15)
        .myShadow()
    }
}

struct NewsItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewsHomeView().environmentObject(NewsApiService())
    }
}
