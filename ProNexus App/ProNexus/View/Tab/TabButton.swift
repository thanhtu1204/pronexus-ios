//
//  TabButton.swift
//  ProNexus
//
//  Created by IMAC on 10/31/21.
//

import SwiftUI

struct TabButton: View {
    var title : String
    var id: String
    @Binding var selectedTab : String
    @State var onSelectTab : () -> Void = {}
    var body: some View {
        Button(action: {
            self.onSelectTab()
            selectedTab = id
            
        }, label: {
            
            HStack(alignment: .center, spacing: 0, content: {
                
                Text(title)
                    .myFont(style: .body, weight: .bold, size: 14, color: selectedTab == id ? Color(hex: "#4d4d4d") : Color(hex: "#cccccc"))
                    .padding(.bottom, 5)
                    .overlay(
                        Capsule().fill(selectedTab == id ? Color.black : .white)
                        .frame( height: 3).offset(y: 2)
                        , alignment: .bottom)
                
                // adding animation...
                
//                if selectedTab == id {
//
//                    Capsule()
//                        .fill(Color.black)
//                        .frame( height: 1.5)
////                        .matchedGeometryEffect(id: "Tab")
//                } else
//                {
//                    Capsule()
//                        .fill(Color.white)
//                        .frame( height: 1.5)
//                }
            })
            // default width...
//                .frame(width: 80)
        })
    }
}

struct NotificationViewbtn_Previews: PreviewProvider {
    static var previews: some View {
        NotificationViewPreview()
    }
}
