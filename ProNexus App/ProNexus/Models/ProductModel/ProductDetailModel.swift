//
//  ProductDetailModel.swift
//  ProNexus
//
//  Created by TUYEN on 11/19/21.
//

import Foundation
import SwiftUI

// MARK: - Hello
struct ProductDetailResponseModel: Codable {
    var ok: Bool?
    var message: String?
    var payload: ProductDetailModel?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct ProductDetailModel: Codable {
    var productID, productCategoryID: Int?
    var productCategoryName, name, description: String?
    var type, status: Int?
    var url: String?
    var price, pricePercentDiscount, wishlistCount, buyCount: Int?
    var viewCount: Int?
    var createdOn: String?
    var createdBy: Int?
    var updatedOn: String?
    var updatedBy: Int?
    var isBuy, isFavorite, isUseURL: Bool?
    var mediaURLList: [String]?
    var rating: Int?
    var organizationName: String?
    var mediaUrl: String?

    enum CodingKeys: String, CodingKey {
        case productID = "ProductId"
        case productCategoryID = "ProductCategoryId"
        case productCategoryName = "ProductCategoryName"
        case name = "Name"
        case description = "Description"
        case type = "Type"
        case status = "Status"
        case url = "Url"
        case price = "Price"
        case pricePercentDiscount = "PricePercentDiscount"
        case wishlistCount = "WishlistCount"
        case buyCount = "BuyCount"
        case viewCount = "ViewCount"
        case createdOn = "CreatedOn"
        case createdBy = "CreatedBy"
        case updatedOn = "UpdatedOn"
        case updatedBy = "UpdatedBy"
        case isBuy = "IsBuy"
        case isFavorite = "IsFavorite"
        case isUseURL = "IsUseUrl"
        case mediaURLList = "MediaUrlList"
        case rating = "Rating"
        case organizationName = "OrganizationName"
        case mediaUrl = "MediaUrl"
    }
    
    func priceOld() -> String {
        return "\(Float(self.price ?? 0)) đ"
    }
    
    func priceNew() -> String {
        let priceOld = Float(self.price ?? 0)
        let discount = Float(self.pricePercentDiscount ?? 0)
        return "\(priceOld - ((priceOld * discount) / 100))"
    }
    
    func productImage() -> String {
        return self.mediaUrl.isEmptyOrNil ? "https://sternbergclinic.com.au/wp-content/uploads/2020/03/placeholder.png" : self.mediaUrl!
    }
}
