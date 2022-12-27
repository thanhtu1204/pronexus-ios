//
//  RattingView.swift
//  ProNexus
//
//  Created by Tú Dev app on 16/11/2021.
//

import SwiftUI

struct RattingView: View {
    @Binding var rating: Int

    var label = ""

    var maximumRating = 5

    var offImage = Image("ic_star")
    var onImage = Image("ic_star_fill")

    var offColor = Color(hex: "#FFC700")
    var onColor =  Color(hex: "#FFC700")
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number).resizable()
                    .frame(width: 23, height: 23, alignment: .center)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }

            }
        }
        
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage
        } else {
            return onImage
        }
    }
}

struct RattingView_Previews: PreviewProvider {
    static var previews: some View {
        RattingView(rating: .constant(4))
    }
}
