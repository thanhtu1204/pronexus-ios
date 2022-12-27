//
//  FieldLabel.swift
//  ProNexus
//
//  Created by thanh cto on 19/11/2021.
//

import SwiftUI

struct FieldLabel: View {
    var label: String
    var required: Bool
    var labelColor = "#A4A4A4"
    var body: some View {
        HStack {
            Text(label)
                .appFont(style: .body, size: 16, color: Color(hex:labelColor ))
            if required {
                HStack(alignment: .center, spacing: 0){
                    Text("(")
                        .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                    Text("*")
                        .appFont(style: .body, size: 16, color: Color(hex: "#FF0000")).padding(.top, 5)
                    Text(")")
                        .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                }
            }
        }
    }
}

struct ToolsFieldLabel: View {
    var label: String
    var required: Bool
    var labelColor = "#A4A4A4"
    var body: some View {
        HStack {
            Text(label)
                .appFont(style: .body, size: 10, color: Color(hex:"#4D4D4D" ))
            if required {
                HStack(alignment: .center, spacing: 0){
                    Text("(")
                        .appFont(style: .body, size: 12, color: Color(hex: "#A4A4A4"))
                    Text("*")
                        .appFont(style: .body, size: 12, color: Color(hex: "#FF0000")).padding(.top, 5)
                    Text(")")
                        .appFont(style: .body, size: 12, color: Color(hex: "#A4A4A4"))
                }
            }
        }
    }
}

struct FormLabel_Previews: PreviewProvider {
    static var previews: some View {
        FieldLabel(label: "Label Field", required: true)
    }
}
