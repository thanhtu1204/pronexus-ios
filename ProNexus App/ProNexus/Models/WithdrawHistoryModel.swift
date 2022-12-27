//
//  WithdrawHistoryModel.swift
//  ProNexus
//
//  Created by TUYEN on 11/26/21.
//

import Foundation

struct WithdrawHistoryModelResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: [WithdrawHistoryModel]?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct WithdrawHistoryModel: Codable,Identifiable {
    var id = UUID()
    var providerUsageRequestID, providerID: Int?
    var payloadDescription: String?
    var amount: Double = 0
    var type, status: Int?
    var createdOn: String?
    var createdBy: Int?
    var updatedOn: String?
    var updatedBy, bankID: Int?
    var bankAccount: String?
    var bankName: String?
    var bankFullName: String?

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
        case bankFullName = "BankFullName"
    }
}
