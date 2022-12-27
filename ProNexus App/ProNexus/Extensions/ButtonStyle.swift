//
//  ButtonStyle.swift
//  ProNexus
//
//  Created by thanh cto on 03/11/2021.
//

import Foundation
import SwiftUI

struct BlueButton: ButtonStyle {
    var w = 250.0
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .myFont(style: .body, weight: .regular, size: 14, color: Color(hex: "#ffffff"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .frame(width: w, height: 45)
            .background(Color(hex: "#4C99F8"))
            .cornerRadius(60)
            .myShadow()
        
    }
}

struct BlueButtonBorder: ButtonStyle {
    var w = 250.0
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: w, height: 45, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 30).style(
                withStroke: Color(hex: "#4C99F8"),
                lineWidth: 0.5,
                fill: .white
            ))
        
    }
}


struct ButtonLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .myFont(style: .body, weight: .regular, size: 14, color: Color(hex: "#4C99F8"))
            .foregroundColor(Color(hex: "#4C99F8"))
            .clipShape(Capsule())
            .frame(width: 250, height: 45)
            .background(Color(hex: "#ffffff"))
        
    }
}


struct RedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .myFont(style: .body, weight: .regular, size: 14, color: Color(hex: "#ffffff"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .frame(width: 250, height: 45)
            .background(Color(hex: "#FF0000"))
            .cornerRadius(60)
            .myShadow()
        
    }
}

struct GreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .myFont(style: .body, weight: .regular, size: 14, color: Color(hex: "#ffffff"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .frame(width: 250, height: 45)
            .background(Color(hex: "#49D472"))
            .cornerRadius(60)
            .myShadow()
        
    }
}

struct SilverButton: ButtonStyle {
    var w = 250.0
    var h = 45.0
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .myFont(style: .body, weight: .regular, size: 14, color: Color(hex: "#808080"))
            .foregroundColor(Color(hex: "#808080"))
            .clipShape(Capsule())
            .frame(width: w, height: h)
            .background(Color(hex: "#E6E6E6"))
            .cornerRadius(60)
            .myShadow()
        
    }
}

struct GradientButtonStyleChat: ButtonStyle {
    var w: CGFloat = 87.0
    var h: CGFloat = 38.0
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .myFont(style: .body, weight: .regular, size: 14, color: Color(hex: "#808080"))
            .foregroundColor(Color(hex: "#808080"))
            .clipShape(Capsule())
            .frame(width: w, height: h)
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#032BBF"), Color(hex: "#50A0FC")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            .myShadow()
    }
}


struct YellowButton: ButtonStyle {
    var w = 250.0
    var h = 45.0
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .myFont(style: .body, weight: .regular, size: 14, color: Color(hex: "#ffffff"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .frame(width: w, height: h)
            .background(Color(hex: "#F29F13"))
            .cornerRadius(60)
            .myShadow()
        
    }
}

struct BorderButton: ButtonStyle {
    @State var isSelected = false
    var w = 80.0
    var h = 36.0
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .myFont(style: .body, weight: .regular, size: 14, color: isSelected ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
            .frame(minWidth: w, idealWidth: w, maxWidth: w, minHeight: h, idealHeight: h, maxHeight: h, alignment: .center)
            .padding(.horizontal, 8)
            .foregroundColor(isSelected ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
            .background(RoundedRectangle(cornerRadius: 30).style(
                withStroke: isSelected ? Color(hex: "#4C99F8") : Color(hex: "#B3B3B3"),
                lineWidth: 0.5,
                fill: .white
            ))
    }
}

struct BorderButtonSelected: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 75, minHeight: 36, idealHeight: 36, maxHeight: 36, alignment: .center)
            .myFont(style: .body, weight: .regular, size: 14, color: isSelected ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
            .padding(.horizontal, 8)
            .foregroundColor(isSelected ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
            .background(RoundedRectangle(cornerRadius: 30).style(
                withStroke: isSelected ? Color(hex: "#4C99F8") : Color(hex: "#B3B3B3"),
                lineWidth: 0.5,
                fill: .white
            ))
    }
}



struct BorderButtonTimeSelected: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 60, minHeight: 30, alignment: .center)
            .myFont(style: .body, weight: .regular, size: 12, color: isSelected ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
            .padding(.horizontal, 8)
            .foregroundColor(isSelected ? Color(hex: "#4C99F8") : Color(hex: "#808080"))
            .background(RoundedRectangle(cornerRadius: 30).style(
                withStroke: isSelected ? Color(hex: "#4C99F8") : Color(hex: "#B3B3B3"),
                lineWidth: 0.5,
                fill: .white
            ))
    }
}

struct ButtonStylesContentView: View
{
    var body: some View {
        VStack (alignment: .center, spacing: 10) {
            
            Button(action: {}, label: {
                Text("Button").appFont(style: .body, color: .white)
            }).buttonStyle(BorderButton())
            
            Button(action: {}, label: {
                Text("Button").appFont(style: .body, color: Color(hex: "#4C99F8"))
            }).buttonStyle(BlueButtonBorder())
            
            Button(action: {}, label: {
                Text("Button").appFont(style: .body, color: .white)
            }).buttonStyle(BorderButton())
            
            Button(action: {}, label: {
                Text("Button").appFont(style: .body, color: .white)
            }).buttonStyle(BorderButton())
            
            
            Button(action: {}, label: {
                Text("Button").appFont(style: .body, color: .white)
            }).buttonStyle(BorderButton())
            
            
            Button(action: {}, label: {
                Text("Button").appFont(style: .body, color: .white)
            }).buttonStyle(BorderButton())
            
            
            Button(action: {}, label: {
                Text("Button").appFont(style: .body, color: .white)
            }).buttonStyle(BorderButton())
            
            
            Button(action: {}, label: {
                Text("Button").appFont(style: .body, color: .white)
            }).buttonStyle(BorderButton())
        }
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStylesContentView()
    }
}
