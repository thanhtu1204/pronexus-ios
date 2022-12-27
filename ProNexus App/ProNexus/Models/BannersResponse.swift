//
//  Banner.swift
//  ProNexus
//
//  Created by thanh cto on 11/10/2021.
//

import Foundation

class BannersResponse: Codable {
    var ok: Bool?
    var message: String?
    var results: [BannerModel]? = nil
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case results = "Payload"
        case count = "Count"
    }
}

class BannerModel: Codable, Identifiable {
    var id: Int?
    var title, content: String?
    var startDate: String?
    var endDate: String?
    var mediaURL: String?
    var mediaID: Int?
    var bannerURL: String?
    var type, status: Int?
    var createdOn: String?
    var createdBy: Int?
    var updatedOn: String?
    var updatedBy: Int?
    var mediaNoteContent, mediaName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "BannerId"
        case title = "Title"
        case content = "Content"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case mediaURL = "MediaURL"
        case mediaID = "MediaId"
        case bannerURL = "BannerURL"
        case type = "Type"
        case status = "Status"
        case createdOn = "CreatedOn"
        case createdBy = "CreatedBy"
        case updatedOn = "UpdatedOn"
        case updatedBy = "UpdatedBy"
        case mediaNoteContent = "MediaNoteContent"
        case mediaName = "MediaName"
    }
    
}
