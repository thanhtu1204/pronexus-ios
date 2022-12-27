//
//  NoData.swift
//  ProNexus
//
//  Created by thanh cto on 09/11/2021.
//

import SwiftUI

struct NoData: View {
    var text: String?
    var w = 120.0
    var h = 60.0
    var body: some View {
        VStack (alignment: .center) {
            Text(text ?? "Không có dữ liệu").appFont(style: .caption1).fixedSize(horizontal: true, vertical: false)
            Image(systemName: "tray").resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fill)
                .frame(width: 18, height: 18)
                .foregroundColor(Color(hex: "#808080"))
        }
        .padding(.vertical, 10)
        .frame(width: w, height: h, alignment: .center)
        .background(Color.white)
    }
}

struct NoData_Previews: PreviewProvider {
    static var previews: some View {
        NoData()
    }
}
