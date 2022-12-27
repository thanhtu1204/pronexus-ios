//
//  ScheduleCustomer.swift
//  ProNexus
//
//  Created by thanh cto on 12/11/2021.
//

import Foundation

// danh sách lịch hẹn của advisor, customer
class ScheduleCustomerResponseModel: Codable {
    var ok: Bool?
    var message: String?
    var data: [ScheduleCustomerModel] = []
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case data = "Payload"
        case count = "Count"
    }
}

// danh sách lịch hẹn của advisor, customer
class ScheduleCustomerDetailResponseModel: Codable {
    var ok: Bool?
    var message: String?
    var data: ScheduleCustomerModel?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case data = "Payload"
        case count = "Count"
    }
}

class ScheduleCustomerModel: Codable,Identifiable {
    var id = UUID()
    var scheduleOrderID: Int?
    var adviseType, startDate, endDate ,startHour: String?
    var adviseHours: Int?
    var advisorID: Int?
    var customerID: Int?
    var firstName, lastName, phone: String?
    var status: Int?
    var scheduleType: String?
    var classificationList: [ScheduleCustomerClassificationListModel]?
    var sessionList: [String]?
    var createdDate, updatedDate, mediaURL: String?
    var note: String?
    var price: Int?
    var rating: Double?
    var jobTitle: String?
    var advisorProvince: String?
    var advisorDistrict: String?
    var advisorMediaUrl: String?
    var advisorName: String?
    
    var customerProvince: String?
    var customerDistrict: String?
    var customerName: String?
    var customerMediaUrl: String?
    var ratingSpecialize : Double?
    var ratingExperience : Double?
    var ratingService : Double?

    enum CodingKeys: String, CodingKey {
        case scheduleOrderID = "ScheduleOrderId"
        case adviseType = "AdviseType"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case adviseHours = "AdviseHours"
        case firstName = "FirstName"
        case lastName = "LastName"
        case phone = "Phone"
        case status = "Status"
        case scheduleType = "ScheduleType"
        case classificationList = "ClassificationList"
        case sessionList = "SessionList"
        case createdDate = "CreatedDate"
        case updatedDate = "UpdatedDate"
        case mediaURL = "MediaUrl"
        case note = "Note"
        case price = "Price"
        case startHour = "StartHour"
        case rating = "rating"
        case jobTitle = "JobTitle"
        case customerID = "CustomerId"
        case customerName = "CustomerName"
        case customerProvince = "CustomerProvince"
        case customerDistrict = "CustomerDistrict"
        case customerMediaUrl = "CustomerMediaUrl"
        case advisorID = "AdvisorId"
        case advisorName = "AdvisorName"
        case advisorProvince = "AdvisorProvince"
        case advisorDistrict = "AdvisorDistrict"
        case advisorMediaUrl = "AdvisorMediaUrl"
        case ratingSpecialize = "RatingSpecialize"
        case ratingExperience = "RatingExperience"
        case ratingService = "RatingService"
    }
    
    func advisorAvgRate() -> Double {
        let rating = (((self.ratingService ?? 0) + (self.ratingExperience ?? 0) + (self.ratingSpecialize ?? 0)) / 3)
        return rating > 0 ? Double(rating).round(to: 1) : 0
    }
}

// MARK: - childrenCategoriesClassificationList
class ScheduleCustomerClassificationListModel: Codable,Identifiable {
    var classificationID: Int?
    var name, classificationListDescription: String?

    enum CodingKeys: String, CodingKey {
        case classificationID = "ClassificationId"
        case name = "Name"
        case classificationListDescription = "Description"
    }
}
