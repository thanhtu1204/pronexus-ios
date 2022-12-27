//
//  ContainerView.swift
//  ProNexus
//
//  Created by thanh cto on 19/11/2021.
//

import SwiftUI

struct ContainerView<Content: View>: View {
    
    @Binding var loading: Bool
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack {
            if $loading.wrappedValue {
                VStack (alignment: .center) {
                    Spacer()
                    SectionLoader()
                    Spacer()
                }
            } else {
                content().onAppear {
                    NotificationCenter.default.post(name: .didHiddenTabBar, object: nil, userInfo: nil)
                }.onDisappear {
                    NotificationCenter.default.post(name: .didShowTabBar, object: nil, userInfo: nil)
                }
            }
        }
    }
}

//struct ScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScreenView()
//    }
//}
