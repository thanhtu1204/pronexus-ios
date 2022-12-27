//
//  SectionTitleDropdown.swift
//  ProNexus
//
//  Created by Tú Dev app on 03/11/2021.
//

import Foundation
import SwiftUI

struct SectionTitleDropdown: View {
    let title: String
    @State var showActionSheet: Bool = false
    @State var textSelection = "7 Ngày trước"
    @Binding var selection: Int
    
    var actionSheet: ActionSheet {
            ActionSheet(title: Text("Thời gian"), message: Text("Chọn thời gian"), buttons: [
                .default(Text(textSelection)) {
                    selection = 7
                    textSelection = textSelection
                },
                .default(Text("30 ngày trước")) {
                    selection = 30
                    textSelection = "30 ngày trước"
                },
                .default(Text("Tất cả")) {
                    selection = 0
                    textSelection = "Tất cả"
                },
                .destructive(Text("Đóng"))
            ])
        }
    
    var body: some View {
        HStack {
            Text(title).appFont(style: .title1, weight: .bold)
            
            Spacer()
            
            //            Text("See All")
            //                .foregroundColor(.blue)
            //                .onTapGesture {
            //
            //                }
            VStack{
                HStack {
                    Text(textSelection).appFont(style: .caption1, weight: .regular, size: 10, color: Color(hex: "#808080")).frame(width: 78)
                    
                    //                        Image(systemName: expand ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill").resizable().frame(width: 8, height: 6).foregroundColor(.gray)
                    Image(systemName:
                            "arrowtriangle.down.fill").resizable().frame(width: 6, height: 4).foregroundColor(.gray)
                }.onTapGesture{
                    //                        self.expand.toggle()
                    self.showActionSheet.toggle()
                    
                }
                //                    if expand {
                //                        ForEach(results) { item in
                //                            Text(item.name ?? "").appFont(style: .caption1, weight: .regular, size: 12, color: Color(hex: "#808080")).onTapGesture {
                //                                  selectCatName = item.name ?? ""
                //                                  self.expand.toggle()
                //                                if let catId = item.id
                //                                {
                //                                    newsService.loadNewsByCatID(id: catId)
                //                                }
                //                            }.padding(.all, 5)
                //                        }
                //                    }
            } .padding(.vertical,4)
                .padding(.horizontal, 2)
                .background(Color.white)
                .cornerRadius(3)
                .myShadow()
                .actionSheet(isPresented: $showActionSheet, content: {
                            self.actionSheet })
            //                        .animation(.spring())
                .alignmentGuide(VerticalAlignment.firstTextBaseline) { $0[.top] }    // << here !!
            
            
        }
        
        //    }.offset(y: 10)
        //            .padding(.horizontal, 37)
        //            .padding(.top, 0)
        //            .padding(.bottom, 90)
        
    }
}
