//
//  CreatePaymentVnPayResponse.swift
//  ProNexus
//
//  Created by thanh cto on 15/11/2021.
//

import Foundation

class CreatePaymentVnPayResponse: Codable {
    var ok: Bool = false
    var message: String = ""
    var payload: String?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
    }
}
