//
//  BottomSheetView.swift
//  ProNexus
//
//  Created by thanh cto on 19/11/2021.
//

import SwiftUI

fileprivate enum ConstantsModal {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 3
    static let indicatorWidth: CGFloat = 80
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: ConstantsModal.radius)
            .fill(Color(hex: "#E5E5E5"))
            .frame(
                width: ConstantsModal.indicatorWidth,
                height: ConstantsModal.indicatorHeight
        ).onTapGesture {
            self.isOpen.toggle()
        }
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * ConstantsModal.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.white))
            .cornerRadius(ConstantsModal.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * ConstantsModal.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
            //            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 2, x: 0, y: -1)
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(isOpen: .constant(true), maxHeight: UIScreen.screenHeight - 100) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}
