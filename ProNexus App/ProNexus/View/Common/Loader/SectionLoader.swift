//
//  SectionLoader.swift
//  ProNexus
//
//  Created by thanh cto on 16/11/2021.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    typealias UIView = UIActivityIndicatorView
    var isAnimating: Bool
    var configuration = { (indicator: UIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}

extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView)->Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}

struct SectionLoader: View {
    @State var spinCircle = false
    
    var body: some View {
        VStack {
//                Circle()
//                    .trim(from: 0.3, to: 1)
//                    .stroke(Color.gray, lineWidth:1)
//                    .frame(width:24, height: 24)
//                    .padding(.all, 0)
//                    .rotationEffect(.degrees(spinCircle ? 0 : -360), anchor: .center)
//                    .animation(Animation.linear(duration: 0.6).repeatForever(autoreverses: false))
//                    .onAppear {
//                        self.spinCircle = true
//                    }
            ActivityIndicator(isAnimating: true)
                .configure { $0.color = .gray } // Optional configurations (🎁 bouns)
//                    .background(Color.blue)
        }
    }
}

struct SectionLoader_Previews: PreviewProvider {
    static var previews: some View {
        SectionLoader()
    }
}
