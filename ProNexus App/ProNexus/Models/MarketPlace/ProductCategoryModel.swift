//
//  ProductCategoryModel.swift
//  ProNexus
//
//  Created by Tú Dev app on 17/11/2021.
//

import Foundation

// MARK: - Product
struct ProductCategoryList: Codable {
    var ok: Bool?
    var message: String?
    var payload: [ProductCategory]?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct ProductCategory: Codable,Identifiable {
    var id = UUID()
    var productCategoryID: Int?
    var name, payloadDescription: String?
    var type, status: Int?
    var createdOn: String?
    var createdBy: Int?
    var updatedOn: String?
    var updatedBy: Int?
    var backgroundURL: String?
    var iconURL: String?

    enum CodingKeys: String, CodingKey {
        case productCategoryID = "ProductCategoryId"
        case name = "Name"
        case payloadDescription = "Description"
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

