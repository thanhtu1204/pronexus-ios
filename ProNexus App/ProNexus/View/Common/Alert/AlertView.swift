//
//  AlertView.swift
//  ProNexus
//
//  Created by thanh cto on 05/11/2021.
//

import SwiftUI

struct AlertView: View {
    var msg: String
    @Binding var show: Bool
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            Text("Thông báo")
                .appFont(style: .title1)
            
            Text(msg)
                .appFont(style: .body)
            
            Button(action: {
                // closing popup...
                show.toggle()
            }, label: {
                Text("Đóng")
                    .appFont(style: .body)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(Color(hex: "#f2f2f2"))
                    .cornerRadius(15)
            })
            
            // centering the button
            .frame(alignment: .center)
        })
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal,50)
        
        // background dim...
        .frame(maxWidth: screenWidth(), maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }
}

struct AlertContentView: View {
    @State var isShowAlertError = true
    var body: some View {
        if $isShowAlertError.wrappedValue {
            
            AlertView(msg: "Test test", show: $isShowAlertError)
        }
    }
}


struct Alert_Previews: PreviewProvider {
    static var previews: some View {
        AlertContentView()
    }
}
