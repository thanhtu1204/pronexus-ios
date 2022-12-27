//
//  IconMenu.swift
//  ProNexus
//
//  Created by Tú Dev app on 01/11/2021.
//
import SwiftUI

struct IconMenu: View {
    let name: String
    let image: String

    var body: some View {
        VStack {
            Image(image)
                .aspectRatio(1, contentMode: .fill)
                .padding(.bottom, 20)
                .frame(width:30, height: 30, alignment: .center)
            
            Text(name).myFont(style: .body, size: 13)
            
            Spacer()
        }
        .frame(width: 90)
        
    }
}
