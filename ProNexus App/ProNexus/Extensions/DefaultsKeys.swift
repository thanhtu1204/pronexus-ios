//
//  DefaultsKeys.swift
//  ProNexus
//
//  Created by thanh cto on 16/10/2021.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var accessToken: DefaultsKey<String?> { .init("accountToken") }
    var userName: DefaultsKey<String?> { .init("userName") }
    var userFullName: DefaultsKey<String?> { .init("userFullName") }
    var userPicture: DefaultsKey<String?> { .init("userPicture") }
    var userLogger: DefaultsKey<UserProfileModel?> { .init("userLogger") }
    var cartCount: DefaultsKey<Int> { .init("cartCount", defaultValue: 0) }
    var notificationCount: DefaultsKey<Int> { .init("notificationCount", defaultValue: 0) }
    var onBoarding: DefaultsKey<Int> { .init("onBoarding", defaultValue: 0) }
}
