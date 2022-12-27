//
//  CustomAlertView.swift
//  ProNexus
//
//  Created by TUYEN on 11/12/21.
//

import SwiftUI

struct CustomAlertView: View {
    var title: String
    var msg: String
    var textButton1: String? = nil
    var textButton2: String? = nil
    var icon: String? = nil
    var onPressBtn1: () -> Void = {}
    var onPressBtn2: () -> Void = {}
    
    
    @Binding var show: Bool
    var body: some View {
        
        VStack(alignment: .center, spacing: 15, content: {
            
            if let icon = icon {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(.top, 15).padding(.bottom, 10)
                
            }
            
            Text(title)
                .appFont(style: .title1, weight: .bold, size: 20)
            
            Text(msg)
                .appFont(style: .body)
                .padding(.bottom, 15)
            
            if let textButton1 = textButton1 {
                Button(action: onPressBtn1, label: {
                    Text(textButton1)
                        .appFont(style: .body, size: 14, color: Color(hex: "#FFFFFF"))
                        .padding(.vertical)
                    
                })
                .buttonStyle(BlueButton())
                .frame(alignment: .center)
            }
            
            if let textButton2 = textButton2 {
                Button(action: {
                    onPressBtn2()
                    self.show.toggle()
                    
                }, label: {
                    Text(textButton2)
                        .appFont(style: .body, size: 14, color: Color(hex: "#4C99F8"))
                    
                }).frame(alignment: .center)
            }
                
        })
            .padding(20)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal,50)
        
        // background dim...
            .frame(minWidth: 300,  maxWidth: screenWidth(), maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
    }
}

struct CustomAlertContentView: View {
    @State var isShowAlertError = true
    var body: some View {
        if $isShowAlertError.wrappedValue {
            CustomAlertView(title: "title", msg: "lorem is pums 123 lorem", textButton1: "button1", textButton2: "button2", icon: "ic_un_complate", show: $isShowAlertError)            
        }
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertContentView()
    }
}
