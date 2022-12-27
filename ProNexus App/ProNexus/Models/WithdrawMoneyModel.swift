//
//  WithdrawMoneyModel.swift
//  ProNexus
//
//  Created by TUYEN on 11/25/21.
//

import Foundation
struct WithdrawMoneyModelResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: WithdrawMoneyModel?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct WithdrawMoneyModel: Codable {
    var providerUsageRequestID, providerID: Int?
    var payloadDescription: String?
    var amount, type, status: Int?
    var createdOn: String?
    var createdBy: Int?
    var updatedOn: String?
    var updatedBy, bankID: Int?
    var bankAccount, bankName: String?

    enum CodingKeys: String, CodingKey {
        case providerUsageRequestID = "ProviderUsageRequestId"
        case providerID = "ProviderId"
        case payloadDescription = "Description"
        case amount = "Amount"
        case type = "Type"
        case status = "Status"
        case createdOn = "CreatedOn"
        case createdBy = "CreatedBy"
        case updatedOn = "UpdatedOn"
        case updatedBy = "UpdatedBy"
        case bankID = "BankId"
        case bankAccount = "BankAccount"
        case bankName = "BankName"
    }
}
