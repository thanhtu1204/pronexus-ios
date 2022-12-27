//
//  Package2.swift
//  ProNexus
//
//  Created by TUYEN on 12/9/21.
//

import SwiftUI

struct Package2: View {
    let item: Pack2
    let isExpanded: Bool
    
    var body: some View {
        ScrollView (.vertical) {
            VStack(alignment: .leading, spacing: 10) {
                HStack() {
                    Text(item.label).appFont(style: .caption1, weight: .bold, size: 14, color: Color(hex: "#4C99F8"))
                    Spacer()
                        Image(isExpanded ? "arrow_down" : "ic_arrow_right_blue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                }
                .padding(.all, 15)
                .background(RoundedRectangle(cornerRadius: 30).style(
                    withStroke: Color(hex: "#4C99F8"),
                    lineWidth: 0.5,
                    fill: .white
                ))
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(hex: "#4C99F8"))
                if isExpanded {
                    VStack(alignment: .leading, spacing: 15) {
                        Text(item.field1).appFont(style: .caption1, weight: .regular, size: 14)
                        Divider()
                        Text(item.field2).appFont(style: .caption1, weight: .regular, size: 14)
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 15)
                    .padding(.horizontal, 30)
                }
            }

        }
    }
}

