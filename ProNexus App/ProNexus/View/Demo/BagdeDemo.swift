//
//  BagdeDemo.swift
//  ProNexus
//
//  Created by thanh cto on 03/11/2021.
//

import SwiftUI

struct BagdeDemo: View {
    var body: some View {
        Badge(text: "Đầu tư1", textColorHex: "#fff", bgColorHex: "#1D74FE")
        Badge(text: "Đầu tư1", textColorHex: "#fff", bgColorHex: "#FFB300")
        Badge(text: "Đầu tư1", textColorHex: "#fff", bgColorHex: "#4C99F8")
        Badge(text: "Đầu tư1", textColorHex: "#fff", bgColorHex: "#FF0000")
    }
}

struct BagdeDemo_Previews: PreviewProvider {
    static var previews: some View {
        BagdeDemo()
    }
}
