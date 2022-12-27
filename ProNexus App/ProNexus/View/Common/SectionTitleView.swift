//
//  SectionTitleView.swift
//  ProNexus
//
//  Created by Tú Dev app on 03/11/2021.
//


import SwiftUI

struct SectionTitleView<TargetView: View>: View {
    let title: String
    var nextView: TargetView
    
    var body: some View {
        HStack{
            
            Text(title).appFont(style: .title1, weight: .bold)
            
            Spacer()
            NavigationLink(destination: nextView) {
                HStack(spacing: 6){
                    
                    Text("Xem tất cả").appFont(style: .caption2)
                }
            }
        }
    }
}
