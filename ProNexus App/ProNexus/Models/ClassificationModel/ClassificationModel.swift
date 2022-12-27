//
//  ClassificationModel.swift
//  ProNexus
//
//  Created by thanh cto on 31/10/2021.
//


import SwiftUI


// MARK: - ClassificationModel
struct ClassificationListModel: Codable {
    var ok: Bool?
    var message: String?
    var results: [ClassificationModel]? = nil // list classification
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case results = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct ClassificationModel: Identifiable, Codable {
    var id: Int? = 0
    var name: String? = ""
    var description: String?
    var type, status: Int?
    var createdOn: String?
    var createdBy: Int?
    var updatedBy: Int?
    var updatedOn, providerClassificationID, providerID: String?
    var level, packageClassificationID, packageID, pcType: String?
    var pcStatus: String?
    var backgroundUrl: String?
    var iconUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ClassificationId"
        case name = "Name"
        case description = "Description"
        case type = "Type"
        case status = "Status"
        case createdOn = "CreatedOn"
        case createdBy = "CreatedBy"
        case updatedOn = "UpdatedOn"
        case updatedBy = "UpdatedBy"
        case providerClassificationID = "ProviderClassificationId"
        case providerID = "ProviderId"
        case level = "Level"
        case packageClassificationID = "PackageClassificationId"
        case packageID = "PackageId"
        case pcType = "PC_Type"
        case pcStatus = "PC_Status"
        case backgroundUrl = "BackgroundUrl"
        case iconUrl = "IconUrl"
    }
    
    init()
    {
        
    }
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
