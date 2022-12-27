//
//  ItemPerform.swift
//  ProNexus
//
//  Created by Tú Dev app on 01/11/2021.
//

import SwiftUI

struct ItemPerform: View {
    let image: String
    let title: String
    let description: String
    let iconClor: String

    var body: some View {
        
        Button(action:{}){
            VStack(){
                Image(systemName: image)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: iconClor))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(title)
                    .regular(size: 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                Text(description)
                    .regular(size: 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal,10)
            .padding(.vertical, 10)
            .background(Color.white)
           // shadows..
            .cornerRadius(15)
            .myShadow()
            .padding(.horizontal, 2)
            .frame(width: 114, height: 95, alignment: .center)
        }
    }
}

struct ItemPerform_Previews: PreviewProvider {
    static var previews: some View {
        TabRootView().environmentObject(UserApiService()).environmentObject(TabViewSettingModel(currentTab: .Home))
    }
}
