//
//  CustomerCreateScheduleResponse.swift
//  ProNexus
//
//  Created by thanh cto on 13/11/2021.
//

import Foundation

class CustomerCreateScheduleModelResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: CustomerCreateScheduleModel?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
class CustomerCreateScheduleModel: Codable {
    var scheduleOrderID: Int?
    var orderID: Int?
    var scheduleStartDate: String?
    var scheduleEndDate: String?
    var adviseHours: Int?
    var advisorID: Int?
    var scheduleType: String?
    var adviseType: String?
    var createdDate: String?
    var updatedDate: String?
    var scheduleProviderID: String?
    var vnpTxnRef: String? = nil
    var price: Int?
    var startDate: String?
    var endDate: String?
    var note: String?
    var startHour: String?

    enum CodingKeys: String, CodingKey {
        case scheduleOrderID = "ScheduleOrderId"
        case orderID = "OrderId"
        case scheduleStartDate = "ScheduleStartDate"
        case scheduleEndDate = "ScheduleEndDate"
        case adviseHours = "AdviseHours"
        case advisorID = "AdvisorId"
        case scheduleType = "ScheduleType"
        case adviseType = "AdviseType"
        case createdDate = "CreatedDate"
        case updatedDate = "UpdatedDate"
        case scheduleProviderID = "ScheduleProviderId"
        case vnpTxnRef = "VnpTxnRef"
        case price = "Price"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case note = "Note"
        case startHour = "StartHour"
    }
}
