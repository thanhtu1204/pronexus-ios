//
//  EnvironmentValues.swift
//  ProNexus
//
//  Created by thanh cto on 29/10/2021.
//

import Foundation
import SwiftUI

public extension EnvironmentValues {
    var isPreview: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        return false
        #endif
    }
}
