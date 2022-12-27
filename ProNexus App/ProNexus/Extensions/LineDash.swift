//
//  LineDash.swift
//  ProNexus
//
//  Created by Tú Dev app on 28/11/2021.
//

import Foundation
import SwiftUI
struct LineDash: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
