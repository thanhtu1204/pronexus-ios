//
//  ValidatorMessageModifier.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import Foundation
import SwiftUI

struct ValidatorMessageModifier: ViewModifier {
    
    var message:String?
    
    var msg: some View {
        HStack {
            Text( message ?? "")
                .appFont(style: .body, weight: .light, size: 10, color: .red).frame( maxWidth: .infinity, alignment: .leading)
            
        }
    }

    func body(content: Content) -> some View {
        return content.overlay( msg, alignment: .bottom )
    }
}
