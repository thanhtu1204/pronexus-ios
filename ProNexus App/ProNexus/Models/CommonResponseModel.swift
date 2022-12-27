//
//  CommonResponseModel.swift
//  ProNexus
//
//  Created by Tú Dev app on 14/11/2021.
//

import Foundation
struct CommonResponseModel: Codable {
    var ok: Bool = false
    var message: String = ""
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
    }
}
