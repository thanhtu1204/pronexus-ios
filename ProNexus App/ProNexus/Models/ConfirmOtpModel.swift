//
//  ConfirmOtpModel.swift
//  ProNexus
//
//  Created by thanh cto on 06/11/2021.
//

import Foundation

class ConfirmOtpModel : Codable {

    var count : Int?
    var message : String?
    var ok : Bool?
//    var payload : [String: Any]?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case message = "Message"
        case ok = "Ok"
//        case payload = "Payload"
    }
}
