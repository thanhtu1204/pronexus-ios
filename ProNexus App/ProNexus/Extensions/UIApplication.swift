//
//  UIApplication.swift
//  ProNexus
//
//  Created by thanh cto on 11/10/2021.
//

import Foundation
import UIKit

extension UIApplication {
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        
        return shared.statusBarFrame.height
    }
}
