//
//  CreateScheduleModelResponse.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import Foundation

class CreateScheduleModelResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: ScheduleEmptyModel?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}
