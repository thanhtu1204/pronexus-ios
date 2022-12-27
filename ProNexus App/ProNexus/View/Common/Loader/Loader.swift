//
//  Loader.swift
//  SwiftUIWebView
//
//  Created by Md. Yamin on 4/25/20.
//  Copyright © 2020 Md. Yamin. All rights reserved.
//

import SwiftUI

struct Loader: View {
    @State var spinCircle = false
    var body: some View {
        ZStack {
            Rectangle().frame(width:90, height: 90).background(Color.black).cornerRadius(8).opacity(0.1).shadow(color: .black, radius: 16)
            VStack {
                Circle()
                    .trim(from: 0.3, to: 1)
                    .stroke(Color.white, lineWidth:1)
                    .frame(width:24, height: 24)
                    .padding(.all, 0)
                    .rotationEffect(.degrees(spinCircle ? 0 : -360), anchor: .center)
                    .animation(Animation.linear(duration: 0.6).repeatForever(autoreverses: false))
                    .onAppear {
                        self.spinCircle = true
                    }
                Text("Vui lòng đợi.").myFont(style: .body, weight: .regular, size: 12, color: .white)
            }
        }
    }
}


struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
