//
//  TexFieldStyle.swift
//  ProNexus
//
//  Created by thanh cto on 01/11/2021.
//

import Foundation
import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .frame(height: 56)
            .background(Color.white)
            .cornerRadius(30)
        //            .shadow(color: .gray, radius: 30)
            .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 2)
    }
}


struct RoundedTextFieldStyle: TextFieldStyle {
    var height: CGFloat = 45
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color(hex: "#0974DF"), lineWidth: 0.2)
            )
    }
}

struct RoundedTextFieldStyle2: TextFieldStyle {
    var height: CGFloat = 45
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color(hex: "#B3B3B3"), lineWidth: 0.2)
            )
    }
}


struct GradientButtonStyle: ButtonStyle {
    var w: CGFloat = 125
    var height: CGFloat = 45
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .frame(minWidth: w, minHeight: height, idealHeight: height)
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#032BBF"), Color(hex: "#50A0FC")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
    }
}

struct RoundedSilverButtonStyle: ButtonStyle {
    var w: CGFloat = 125
    var height: CGFloat = 45
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .frame(minWidth: w, minHeight: height, idealHeight: height)
            .background(Color(hex: "#CCCCCC"))
            .cornerRadius(15.0)
    }
}
