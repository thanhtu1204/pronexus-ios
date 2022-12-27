//
//  Shape.swift
//  ProNexus
//
//  Created by thanh cto on 08/11/2021.
//

import Foundation
import SwiftUI

extension Shape {
    func style<S: ShapeStyle, F: ShapeStyle>(
        withStroke strokeContent: S,
        lineWidth: CGFloat = 1,
        fill fillContent: F
    ) -> some View {
        self.stroke(strokeContent, lineWidth: lineWidth)
    .background(fill(fillContent))
    }
}
