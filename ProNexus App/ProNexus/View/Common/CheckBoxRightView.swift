//
//  CheckBoxRightView.swift
//  ProNexus
//
//  Created by Tú Dev app on 06/11/2021.
//

import SwiftUI

struct CheckBoxRightView: View {
    @State var isChecked:Bool = false
    @State var item: ClassificationModel?
    @Binding var selections: [Int]
    func toggle() { isChecked = !isChecked}
    
    var body: some View {
        VStack{
            HStack{
                Text(item?.name ?? "").appFont(style: .body, size: 16, color: Color(hex: "#4D4D4D")).padding(.vertical, 0)
                Spacer()
                Button(action: {
                    toggle()
                    if self.selections.contains(item?.id ?? 0) {
                        self.selections.removeAll(where: { $0 == item?.id })
                    }
                    else {
                        self.selections.append(item?.id ?? 0)
                    }
                }) {
                    Image(systemName: isChecked ? "checkmark.square" : "square").foregroundColor(Color.gray)
                }
            }.padding(0)
            Divider()
        }.padding(0)
        
    }
        
}


