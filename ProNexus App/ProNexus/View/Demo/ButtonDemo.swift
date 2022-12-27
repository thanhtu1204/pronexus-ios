//
//  ButtonDemo.swift
//  ProNexus
//
//  Created by thanh cto on 03/11/2021.
//

import Foundation
import SwiftUI

struct ButtonDemo: View {
    var body: some View {
        VStack {
            Button("Press Me") {
                print("Button pressed!")
            }
            .buttonStyle(BlueButton())
            
            Button("Press Me") {
                print("Button pressed!")
            }
            .buttonStyle(RedButton())
            
            Button("Press Me") {
                print("Button pressed!")
            }
            .buttonStyle(GreenButton())
            
            Button("Press Me") {
                print("Button pressed!")
            }
            .buttonStyle(SilverButton())
            
            Button("Press Me") {
                print("Button pressed!")
            }
            .buttonStyle(YellowButton())
            
            
            Button(action: {
                
                
            }) {
                
                Text("Gửi").myFont(style: .body, color: .white)
                
            }.buttonStyle(GradientButtonStyleChat(w: 87.0, h: 38.0))
            
            Button(action: {
                
                
            }) {
                
                Text("Gửi").myFont(style: .body, color: Color(hex: "#4d4d4d"))
                
            }.buttonStyle(SilverButton(w: 87.0, h: 38.0))
        }
    }
}


struct ButtonDemo_Previews: PreviewProvider {
    static var previews: some View {
        ButtonDemo()
    }
}
