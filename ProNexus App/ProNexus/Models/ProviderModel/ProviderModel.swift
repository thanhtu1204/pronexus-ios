//
//  ProviderModel.swift
//  ProNexus
//
//  Created by Tú Dev app on 29/10/2021.
//

import Foundation

// MARK: - Provider
struct AdvisorDetailModel: Codable {
    var ok: Bool?
    var message: String?
    var payload: AdvisorModel?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct AdvisorModel: Codable, Identifiable {
    var id: Int?
    var cardNumber, bankName: String?
    var classificationIDList: String?
    var userProfileID: Int?
    var firstName :  String?
    var lastName :  String?
    var username:  String?
    var introduce:  String?
    var city, state: String?
    var phone :  String?
    var userEmail :  String?
    var identityNumber: String?
    var type: Int?
    var aboutMe: String?
    var bank: String?
    var status: Int?
    var classificationID: String?
    var gender, userProfileStatus: Int?
    var providerName : String?
    var providerMediaURL:  String?
    var district:  String?
    var province:  String?
    var districtID, provinceID: Int?
    var address: String?
    var recommendationCount: Int?
    var bankID: Int?
    var bankAccount: String?
    var createdBy, createdOn, genderDescription: String?
    var dob: String?
    var overall: Double?
    var mediaUrl : String?
    var serviceHours: Int?
    var priceHours: Int?
    var classificationList: [ClassificationModel]?
    var userProfileMediaList: [UserProfileMediaList]?
    var providerClassifications: String?
    var jobTitle : String?
    var yearsExperience : Int?
    var customerCount : Int?
    var company: String?
    var customerId: String?
    var isOnline, isOffline: Bool?
    var ratingSpecialize : Float?
    var ratingExperience : Float?
    var ratingService  : Float?
    var isAvaiable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "AdvisorId" // id advisor
        //        case advisorId = "AdvisorId"
        case customerId = "CustomerId"
        case cardNumber = "CardNumber"
        case bankName = "BankName"
        case classificationIDList = "ClassificationIdList"
        case userProfileID = "UserProfileId"
        case firstName = "FirstName"
        case lastName = "LastName"
        case username = "Username"
        case phone = "Phone"
//        case city = "City"
//        case state = "State"
        case userEmail = "UserEmail"
        case type = "Type"
        case district = "District"
        case province = "Province"
        case aboutMe = "AboutMe"
        case status = "Status"
        case classificationID = "ClassificationId"
        case gender = "Gender"
        case userProfileStatus = "UserProfileStatus"
        case providerName = "AdvisorName"
        case identityNumber = "IdentityNumber"
        case providerMediaURL = "ProviderMediaURL"
        case districtID = "DistrictId"
        case provinceID = "ProvinceId"
        case mediaUrl = "MediaUrl"
        case address = "Address"
        case recommendationCount = "RecommendationCount"
        case bankID = "BankId"
        case bankAccount = "BankAccount"
        case createdBy = "CreatedBy"
        case createdOn = "CreatedOn"
        case genderDescription = "GenderDescription"
        case dob = "DOB"
        case overall = "Overall"
        case serviceHours = "ServiceHours"
        case priceHours = "PriceHours"
        case classificationList = "ClassificationList"
        case userProfileMediaList = "UserProfileMediaList"
        case providerClassifications = "ProviderClassifications"
        case ratingSpecialize = "RatingSpecialize"
        case ratingExperience = "RatingExperience"
        case ratingService = "RatingService"
        case jobTitle = "JobTitle"
        case yearsExperience = "YearsExperience"
        case customerCount = "CustomerCount"
        case company = "Company"
        case isOnline = "IsOnline"
        case isOffline = "IsOffline"
        case isAvaiable = "IsAvaiable"
    }
    
//    func fullName() -> String {
//        return (self.firstName ) + " " + (self.lastName)
//    }
    
    func fullName() -> String {
        return self.providerName ?? ""
    }
//
    func Avatar() -> String {
        if let mediaUrl = self.mediaUrl
        {
            return mediaUrl
        }
        return "https://chinhnhan.vn/uploads/news/no-avata.png"
    }
    
    func advisorAvgRate() -> Double {
        let rating = (((self.ratingService ?? 0) + (self.ratingExperience ?? 0) + (self.ratingSpecialize ?? 0)) / 3)
        return rating > 0 ? Double(rating).round(to: 1) : 0
    }
}


// MARK: - UserProfileMediaList
struct UserProfileMediaList: Codable, Identifiable {
    var id = UUID()
    var userProfileMediaID, mediaID: Int?
    var mediaURL: String?
    var type, status: Int?
    
    enum CodingKeys: String, CodingKey {
        case userProfileMediaID = "UserProfileMediaId"
        case mediaID = "MediaId"
        case mediaURL = "MediaURL"
        case type = "Type"
        case status = "Status"
    }
}

struct ProviderListModel: Codable {
    var ok: Bool?
    var message: String?
    var results: [AdvisorModel]? = nil // list
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case results = "Payload"
        case count = "Count"
    }
}




struct CustomerConectedList: Codable {
    var ok: Bool?
    var message: String?
    var payload: [CustomerConected]?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - TotalProviderIncome
struct CustomerConected: Codable {
    var providerIncomeID, advisorID: Int?
    var advisorName: String?
    var customerID: Int?
    var customerName: String?
    var totalAmount, finalAmount: Int?
    var createdOn: String?
    
    enum CodingKeys: String, CodingKey {
        case providerIncomeID = "ProviderIncomeId"
        case advisorID = "AdvisorId"
        case advisorName = "AdvisorName"
        case customerID = "CustomerId"
        case customerName = "CustomerName"
        case totalAmount = "TotalAmount"
        case finalAmount = "FinalAmount"
        case createdOn = "CreatedOn"
    }
}


// MARK: - ProviderConectedList
struct ProviderConnectedList: Codable {
    var ok: Bool?
    var message: String?
    var payload: [ProviderConnected]?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct ProviderConnected: Codable,Identifiable {
    var id: Int?
    var advisorID, userProfileID: Int?
    var mediaURL: String?
    var firstName = ""
    var lastName = ""
    var userName, phone: String?
    var type: Int?
    var aboutMe: String?
    var userProfileStatus: Int?
    var dob, identityNumber, advisorName, genderDescription: String?
    var gender: Int?
    var userEmail, referCode: String?
    var priceHours: Int?
    var jobTitle, company: String?
    var yearsExperience: Int?
    //    var cv: String?
    var linkURL: String?
    var adviseHours: Int?
    var forthMediaURL, backMediaURL: String?
    var provinceID, districtID: Int?
    var isAvaiable: Bool?
    //    var isOnline, isOffline: Bool?
    var province, district: String?
    //    var customerCount: String?
    var isFeature: Bool?
    //    var certificateMediaList: String?
    var classificationList: [ClassificationListProviderConected]?
    //    var classificationIDS: String?
    var ratingSpecialize : Float?
    var ratingExperience : Float?
    var ratingService  : Float?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case advisorID = "AdvisorId"
        case userProfileID = "UserProfileId"
        case mediaURL = "MediaUrl"
//        case firstName = "FirstName"
//        case lastName = "LastName"
        case userName = "UserName"
        case phone = "Phone"
        case type = "Type"
        case aboutMe = "AboutMe"
        case userProfileStatus = "UserProfileStatus"
//        case dob = "DOB"
        case identityNumber = "IdentityNumber"
        case advisorName = "AdvisorName"
        case genderDescription = "GenderDescription"
        case gender = "Gender"
        case userEmail = "UserEmail"
        case referCode = "ReferCode"
        case priceHours = "PriceHours"
        case jobTitle = "JobTitle"
        case company = "Company"
        case yearsExperience = "YearsExperience"
        //        case cv = "Cv"
        case linkURL = "LinkUrl"
        case adviseHours = "AdviseHours"
        case forthMediaURL = "ForthMediaUrl"
        case backMediaURL = "BackMediaUrl"
        case provinceID = "ProvinceId"
        case districtID = "DistrictId"
        case isAvaiable = "IsAvaiable"
        case ratingSpecialize = "RatingSpecialize"
        case ratingExperience = "RatingExperience"
        case ratingService = "RatingService"
        //        case isOnline = "IsOnline"
        //        case isOffline = "IsOffline"
        case province = "Province"
        case district = "District"
        //        case customerCount = "CustomerCount"
        case isFeature = "IsFeature"
        //        case certificateMediaList = "CertificateMediaList"
        case classificationList = "ClassificationList"
        //        case classificationIDS = "ClassificationIds"
    }
    func fullName() -> String {
        return self.advisorName ?? ""
    }
    
    func advisorAvgRate() -> Double {
        let rating = (((self.ratingService ?? 0) + (self.ratingExperience ?? 0) + (self.ratingSpecialize ?? 0)) / 3)
        return rating > 0 ? Double(rating).round(to: 1) : 0
    }
}

// MARK: - ClassificationList
struct ClassificationListProviderConected: Codable {
    var classificationID: Int?
    var name: String?
    var classificationListDescription, type, status, createdOn: String?
    var createdBy, updatedOn, updatedBy, backgroundURL: String?
    var iconURL: String?
    
    enum CodingKeys: String, CodingKey {
        case classificationID = "ClassificationId"
        case name = "Name"
        case classificationListDescription = "Description"
        case type = "Type"
        case status = "Status"
        case createdOn = "CreatedOn"
        case createdBy = "CreatedBy"
        case updatedOn = "UpdatedOn"
        case updatedBy = "UpdatedBy"
        case backgroundURL = "BackgroundUrl"
        case iconURL = "IconUrl"
    }
}


// MARK: - TotalProviderIncomeList
struct TotalProviderIncomeList: Codable {
    var ok: Bool?
    var message: String?
    var payload: TotalProviderIncome?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct TotalProviderIncome: Codable, Identifiable {
    var id = UUID()
    var totalAmount: Double = 0
    var requestAmount: Double = 0
    var totalCustomer: Int = 0
    var amount: Double = 0
    var adviseHours: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case totalAmount = "TotalAmount" // tổng doanh thu
        case requestAmount = "RequestAmount" // số dư chờ rút
        case totalCustomer = "CustomerCount" // tổng khách hàng
        case amount = "Balance" // số dư
        case adviseHours = "AdviseHours" // Số giờ tư vấn
    }
}

struct ProviderIncomeList: Codable {
    var ok: Bool?
    var message: String?
    var payload: [ProviderIncome]?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
    
}

// MARK: - ProviderIncome
struct ProviderIncome: Codable ,Identifiable{
    var id = UUID()
    var providerIncomeID, advisorID: Int?
    var advisorName: String?
    var customerID: Int?
    var customerName: String?
    var totalAmount, finalAmount: Double?
    var createdOn: String?
    var dateTime: String?
    
    enum CodingKeys: String, CodingKey {
        case providerIncomeID = "ProviderIncomeId"
        case advisorID = "AdvisorId"
        case advisorName = "AdvisorName"
        case customerID = "CustomerId"
        case customerName = "CustomerName"
        case totalAmount = "TotalAmount"
        case finalAmount = "FinalAmount"
        case createdOn = "CreatedOn"
        case dateTime = "DateTime"
    }
}


// MARK: - CustomerConnectedList
struct CustomerConnectedList: Codable {
    var ok: Bool?
    var message: String?
    var payload: [CustomerConnected]?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - CustomerConnected
struct CustomerConnected: Codable,Identifiable {
    var id: String?
    var customerID, userProfileID: Int?
    var firstName = ""
    var lastName = ""
    var  phone: String?
    var userEmail: String?
    var aboutMe: String?
    var type, userProfileStatus, gender: Int?
    var dob: String?
    var identityNumber: String?
    var provinceID: Int?
    var fullName, province: String?
    var districtID: Int?
    var district: String?
    var mediaURL, forthMediaURL, backMediaURL: String?
    var genderDescription: String?
    var referCode: String?
    var rating: Int?

    
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
        case mediaURL = "MediaUrl"
        case forthMediaURL = "ForthMediaUrl"
        case backMediaURL = "BackMediaUrl"
        case genderDescription = "GenderDescription"
        case referCode = "ReferCode"
        case rating = "Rating"
    }
    
}


// MARK: - AdvisorFavoriteList
struct AdvisorFavoriteList: Codable {
    var ok: Bool?
    var message: String?
    var payload: [AdvisorFavoriteItem]?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - AdvisorFavoriteItem
struct AdvisorFavoriteItem: Codable, Identifiable {
    var advisorFavoriteID: Int?
    var id = UUID()
    var advisorID: Int?
    var mediaURL: String? // ví dụ các field khác với advisor
    var  userName, phone: String?
    var firstName = ""
    var lastName = ""
    var type: Int?
    var aboutMe: String?
    var userProfileStatus: Int?
    var dob, identityNumber, advisorName, genderDescription: String?
    var gender: Int?
    var userEmail, referCode: String?
    var priceHours: Int?
    var jobTitle, company: String?
    var yearsExperience: Int?
//    var cv: JSONNull?
    var linkURL: String?
    var adviseHours: Int?
    var forthMediaURL, backMediaURL: String?
    var provinceID, districtID: Int?
    var isAvaiable: Bool?
//    var isOnline, isOffline: JSONNull?
    var province, district: String?
    var customerCount : Int?
    var isFeature: Bool?
//    var certificateMediaList: JSONNull?
    var classificationList: [ClassificationListAdvisorFavoriteItem]?
    var ratingSpecialize : Float?
    var ratingExperience : Float?
    var ratingService  : Float?

    enum CodingKeys: String, CodingKey {
        case advisorFavoriteID = "AdvisorFavoriteId"
        case advisorID = "AdvisorId"
        case mediaURL = "MediaUrl"
//        case firstName = "FirstName"
//        case lastName = "LastName"
        case userName = "UserName"
        case phone = "Phone"
        case type = "Type"
        case aboutMe = "AboutMe"
        case userProfileStatus = "UserProfileStatus"
//        case dob = "Dob"
        case identityNumber = "IdentityNumber"
        case advisorName = "AdvisorName"
        case genderDescription = "GenderDescription"
        case userEmail = "UserEmail"
        case priceHours = "PriceHours"
        case jobTitle = "JobTitle"
        case company = "Company"
        case yearsExperience = "YearsExperience"
//        case cv = "Cv"
        case linkURL = "LinkUrl"
        case adviseHours = "AdviseHours"
//        case forthMediaURL = "ForthMediaUrl"
//        case backMediaURL = "BackMediaUrl"
        case provinceID = "ProvinceId"
        case districtID = "DistrictId"
        case isAvaiable = "IsAvaiable"
//        case isOnline = "IsOnline"
//        case isOffline = "IsOffline"
        case province = "Province"
        case district = "District"
        case customerCount = "CustomerCount"
        case isFeature = "IsFeature"
//        case certificateMediaList = "CertificateMediaList"
        case classificationList = "ClassificationList"
        case ratingSpecialize = "RatingSpecialize"
        case ratingExperience = "RatingExperience"
        case ratingService = "RatingService"
    }
    func fullName() -> String {
        return self.advisorName ?? ""
    }
    
    func Avatar() -> String {
        if let mediaUrl = self.mediaURL
        {
            return mediaUrl
        }
        return "https://chinhnhan.vn/uploads/news/no-avata.png"
    }
    
    func advisorAvgRate() -> Double {
        let rating = (((self.ratingService ?? 0) + (self.ratingExperience ?? 0) + (self.ratingSpecialize ?? 0)) / 3)
        return rating > 0 ? Double(rating).round(to: 1) : 0
    }
}

// MARK: - ClassificationList
struct ClassificationListAdvisorFavoriteItem: Codable {
    var classificationID: Int?
    var name: String?
    var classificationListDescription, type, status, createdOn: String?
    var createdBy, updatedOn, updatedBy, backgroundURL: String?
    var iconURL: String?

    enum CodingKeys: String, CodingKey {
        case classificationID = "ClassificationId"
        case name = "Name"
        case classificationListDescription = "Description"
        case type = "Type"
        case status = "Status"
        case createdOn = "CreatedOn"
        case createdBy = "CreatedBy"
        case updatedOn = "UpdatedOn"
        case updatedBy = "UpdatedBy"
        case backgroundURL = "BackgroundUrl"
        case iconURL = "IconUrl"
    }
}


// MARK: - AdvisorFeedback
struct AdvisorFeedback: Codable {
    var ok: Bool = false
    var message: String?
    var payload: AdvisorFeedbackDetail?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - AdvisorFeedbackDetail
struct AdvisorFeedbackDetail: Codable {
    var advisorRatingID, providerID, userProfileID, ratingSpecialize: Int?
    var ratingExperience, ratingService: Int?
    var noteSpecialize, noteExperience, noteService, createdOn: String?

    enum CodingKeys: String, CodingKey {
        case advisorRatingID = "AdvisorRatingId"
        case providerID = "ProviderId"
        case userProfileID = "UserProfileId"
        case ratingSpecialize = "RatingSpecialize"
        case ratingExperience = "RatingExperience"
        case ratingService = "RatingService"
        case noteSpecialize = "NoteSpecialize"
        case noteExperience = "NoteExperience"
        case noteService = "NoteService"
        case createdOn = "CreatedOn"
    }
}

// MARK: - Notification
struct NotificationList: Codable {
    var ok: Bool?
    var message: String?
    var payload: [NotificationItem]?
    var count: Int?
    var unReadCount: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
        case unReadCount = "UnreadCount"
    }
}

// MARK: - Payload
struct NotificationItem: Codable, Identifiable {
    var id = UUID()
    var announcementID: Int?
    var title: String = ""
    var content: String = ""
    var startDate, endDate: String?
    var type, status: Int?
    var mediaURL: String?
    var isSystem, isRead: Bool?
    var detailID: Int?

    enum CodingKeys: String, CodingKey {
        case announcementID = "AnnouncementId"
        case title = "Title"
        case content = "Content"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case type = "Type"
        case status = "Status"
        case mediaURL = "MediaUrl"
        case isSystem = "IsSystem"
        case isRead = "IsRead"
        case detailID = "DetailId"
    }
}

