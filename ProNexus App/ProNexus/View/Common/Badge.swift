//
//  Badge.swift
//  ProNexus
//
//  Created by thanh cto on 02/11/2021.
//

import SwiftUI

struct Badge: View {
    var text: String = ""
    var textColorHex: String = "#333333"
    var bgColorHex: String = "#333333"
    var textSize = 12.0
    
    var body: some View {
        return ZStack(alignment: .leading) {
            Text(text)
                .font(.custom(Theme.fontName.regular.rawValue, size: textSize)).italic()
                .padding(.leading, 6)
                .padding(.trailing, 6)
                .padding(.top, 4).padding(.bottom, 4)
                .background(bgColorHex.isBlank ? Color.random :  Color(hex: bgColorHex))
                .foregroundColor(Color(hex: textColorHex))
                .frame(height: 16)
                .cornerRadius(15)
            
        }
    }
}
