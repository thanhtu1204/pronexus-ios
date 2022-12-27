//
//  CreateOrderModelResponse.swift
//  ProNexus
//
//  Created by TUYEN on 11/20/21.
//


import Foundation

class CreateOrderModelResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: CreateOrderModel?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
class CreateOrderModel: Codable {
    var orderID: Int?
    var vnpTxnRef: String? = nil

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderId"
        case vnpTxnRef = "VnpTxnRef"
    }
}
