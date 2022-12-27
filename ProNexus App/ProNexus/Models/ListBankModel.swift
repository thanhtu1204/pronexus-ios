//
//  ListBankModel.swift
//  ProNexus
//
//  Created by TUYEN on 11/28/21.
//

import Foundation

struct ListBankModelResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: [ListBankModel]?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct ListBankModel: Codable,Identifiable {
    var id = UUID()
    var bankID: Int?
    var name, payloadDescription: String?
    var type, status: Int?
    var createdOn: String?
    var createdBy, updatedOn, updatedBy: String?

    enum CodingKeys: String, CodingKey {
        case bankID = "BankId"
        case name = "Name"
        case payloadDescription = "Description"
        case type = "Type"
        case status = "Status"
        case createdOn = "CreatedOn"
        case createdBy = "CreatedBy"
        case updatedOn = "UpdatedOn"
        case updatedBy = "UpdatedBy"
    }
}
