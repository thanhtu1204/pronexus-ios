//
//  StartView.swift
//  ProNexus
//
//  Created by thanh cto on 04/11/2021.
//

import SwiftUI

struct StarsView: View {
    private static let MAX_RATING: Float = 5 // Defines upper limit of the rating
    private static let COLOR = Color(hex: "#FFC700") // The color of the stars
    
    let rating: Float
    private let fullCount: Int
    private let emptyCount: Int
    private let halfFullCount: Int
    
    init(rating: Float) {
        self.rating = rating
        fullCount = Int(rating)
        emptyCount = Int(StarsView.MAX_RATING - rating)
        halfFullCount = (Float(fullCount + emptyCount) < StarsView.MAX_RATING) ? 1 : 0
    }
    
    var body: some View {
        HStack (spacing: 2) {
            ForEach(0..<fullCount) { _ in
                self.fullStar
            }
            ForEach(0..<halfFullCount) { _ in
                self.halfFullStar
            }
            ForEach(0..<emptyCount) { _ in
                self.emptyStar
            }
        }
    }
    
    private var fullStar: some View {
        Image(systemName: "star.fill").resizable().frame(width: 8, height: 8).foregroundColor(StarsView.COLOR)
    }
    
    private var halfFullStar: some View {
        Image(systemName: "star.lefthalf.fill").resizable().frame(width: 8, height: 8).foregroundColor(StarsView.COLOR)
    }
    
    private var emptyStar: some View {
        Image(systemName: "star").resizable().frame(width: 8, height: 8).foregroundColor(StarsView.COLOR)
    }
}

struct StarsView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView(rating: 3.5)
    }
}
