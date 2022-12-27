//
//  ScheduleModel.swift
//  ProNexus
//
//  Created by thanh cto on 09/11/2021.
//

import Foundation

class ScheduleListEmptyModel: Codable {
    var ok: Bool?
    var message: String?
    var list: [ScheduleEmptyModel]? = []
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case list = "Payload"
        case count = "Count"
    }
}

class ScheduleProviderSessionList: Codable, Identifiable {
    var id = UUID()
    var schedulesProviderSession, scheduleProviderID: Int?
    var session: String?
    var isAvailable: Bool?

    enum CodingKeys: String, CodingKey {
        case schedulesProviderSession = "SchedulesProviderSession"
        case scheduleProviderID = "ScheduleProviderId"
        case session = "Session"
        case isAvailable = "IsAvailable"
    }
}

// MARK: - childrenCategoriesPayload
class ScheduleEmptyModel: Codable, Identifiable {
    var id = UUID()
    var providerID: Int?
    var startDate, endDate, payloadDescription: String?
    var status: Int?
    var createdDate: String?
    var createdBy, updatedBy: Int?
    var updatedDate: String?
    var sessionList: [String]?
    var scheduleAdvisorID: Int?
    var helloDescription: String?
    var scheduleProviderSessionList: [ScheduleProviderSessionList]?

    enum CodingKeys: String, CodingKey {
        case providerID = "ProviderId"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case status = "Status"
        case createdDate = "CreatedDate"
        case createdBy = "CreatedBy"
        case updatedDate = "UpdatedDate"
        case updatedBy = "UpdatedBy"
        case sessionList = "SessionList"
        case scheduleAdvisorID = "ScheduleAdvisorId"
        case helloDescription = "Description"
        case scheduleProviderSessionList = "ScheduleProviderSessionList"
    }
}
