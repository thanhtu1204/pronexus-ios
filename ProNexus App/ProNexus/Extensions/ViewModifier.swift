//
//  ViewModifier.swift
//  ProNexus
//
//  Created by thanh cto on 01/11/2021.
//

import Foundation
import SwiftUI
import Combine

struct CustomFontModifier: ViewModifier {
    
    var style: UIFont.TextStyle = .body
    var weight: Font.Weight = .regular
    var size: CGFloat = 0 // nếu truyền font size khác thì sẽ lấy theo font size được truyền vào
    var color: Color = .black
    
    var textColor: Color {
        switch style {
        case .body:
            return color != .black ? color : Color (hex: "#808080")
        case .headline:
            return color != .black ? color : .white
        case .title1:
            return color != .black ? color : Color (hex: "#4D4D4D")
        case .caption1:
            return color != .black ? color : Color.black.opacity(0.8)
        case .caption2:
            return color != .black ? color : Color (hex: "#50A0FC")
        default:
            return color != .black ? color : .black
        }
    }
    
    var textSize: CGFloat {
        switch style {
        case .headline:
            return 20
        case .title1:
            return size != 0 ? size : 16
        case .title2:
            return size != 0 ? size : 14
        case .body:
            return size != 0 ? size : 14
        case .caption1:
            return size != 0 ? size : 12
        case .caption2:
            return size != 0 ? size : 10
        default:
            return size
        }
    }
    
    var fontName: String {
        switch weight {
        case .bold:
            return Theme.fontName.bold.rawValue
        default:
            return Theme.fontName.regular.rawValue
        }
    }
    
    //"AvertaStdCY-Regular", "AvertaStdCY-RegularItalic", "AvertaStdCY-Bold"
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom(fontName, size: textSize))
            .foregroundColor(textColor)
    }
    
}


struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}


struct shadowModifier: ViewModifier {
   func body(content: Content) -> some View {
      content
           .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 2, x: 0, y: 1)
   }
}

