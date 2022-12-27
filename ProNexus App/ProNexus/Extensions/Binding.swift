//
//  Binding.swift
//  ProNexus
//
//  Created by Tú Dev app on 14/11/2021.
//
import Foundation
import SwiftUI
extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}

extension Binding {
    
    /// When the `Binding`'s `wrappedValue` changes, the given closure is executed.
    /// - Parameter closure: Chunk of code to execute whenever the value changes.
    /// - Returns: New `Binding`.
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure()
        })
    }
}

//struct ContentView: View {
//    
//    @State private var isLightOn = false
//    
//    var body: some View {
//        Toggle("Light", isOn: $isLightOn.onUpdate(printInfo))
//    }
//    
//    private func printInfo() {
//        if isLightOn {
//            print("Light is now on!")
//        } else {
//            print("Light is now off.")
//        }
//    }
//}
