//
//  CustomerModel.swift
//  ProNexus
//
//  Created by TUYEN on 11/24/21.
//

import Foundation

struct CustomerModelResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: CustomerModel?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct CustomerModel: Codable {
    var id: String?
    var customerID, userProfileID: Int?
    var firstName, lastName, phone, userEmail: String?
    var aboutMe: String?
    var type, userProfileStatus, gender: Int?
    var dob = ""
    var identityNumber: String?
    var provinceID: Int?
    var fullName, province: String?
    var districtID: Int?
    var district, forthMediaURL, backMediaURL: String?
    var genderDescription: String?
    var referCode: String?
    var mediaUrl : String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case customerID = "CustomerId"
        case userProfileID = "UserProfileId"
        case firstName = "FirstName"
        case lastName = "LastName"
        case phone = "Phone"
        case userEmail = "UserEmail"
        case aboutMe = "AboutMe"
        case type = "Type"
        case userProfileStatus = "UserProfileStatus"
        case gender = "Gender"
        case dob = "Dob"
        case identityNumber = "IdentityNumber"
        case provinceID = "ProvinceId"
        case fullName = "FullName"
        case province = "Province"
        case districtID = "DistrictId"
        case district = "District"
        case mediaUrl = "MediaUrl"
        case forthMediaURL = "ForthMediaUrl"
        case backMediaURL = "BackMediaUrl"
        case genderDescription = "GenderDescription"
        case referCode = "ReferCode"
    }
}
