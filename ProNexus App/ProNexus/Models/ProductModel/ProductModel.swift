//
//  ProductModel.swift
//  ProNexus
//
//  Created by Tú Dev app on 09/11/2021.
//
import Foundation

// MARK: - Product
struct ProductListModel: Codable {
    var ok: Bool?
    var message: String?
    var payload: [ProductElement]?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - ProductElement
struct ProductElement: Codable ,Identifiable{
    var id = UUID()
    var productID, productCategoryID, organizationID: Int?
    var productCategoryName: String?
    var name: String?
    var organizationName: String?
    var productDescription: String?
    var price: Int?
    var maxAttendance, amount, mediaURL: String?
    var type, status: Int?
    var feedbackCount: String?
    var myFeedbackRating: Bool?
    var myFeedbackContent, overall: String?
//    var productMediaList: [ProductMediaListNew]?
    var url: String?
    var createdOn: String?
    var createdBy: Int?
    var updatedOn: String?
    var updatedBy, pricePercentDiscount, wishlistCount, buyCount: Int?
    var viewCount: Int?
    var rating: Int?
    var productCartId: Int?
    var productFavoriteId: Int?
    var isFavorite: Bool = false
    var isChecked: Bool?
    var mediaURLList: [String]?

    enum CodingKeys: String, CodingKey {
        case productID = "ProductId"
        case productFavoriteId = "ProductFavoriteId"
        case productCartId = "ProductCartId"
        case productCategoryID = "ProductCategoryId"
        case organizationID = "OrganizationId"
        case productCategoryName = "ProductCategoryName"
        case name = "Name"
        case organizationName = "OrganizationName"
        case productDescription = "Description"
        case price = "Price"
        case maxAttendance = "MaxAttendance"
//        case isFavorite = "IsFavorite"
        case amount = "Amount"
        case mediaURL = "MediaUrl"
        case type = "Type"
        case status = "Status"
        case feedbackCount = "FeedbackCount"
        case myFeedbackRating = "MyFeedbackRating"
        case myFeedbackContent = "MyFeedbackContent"
        case overall = "Overall"
//        case productMediaList = "ProductMediaList"
        case mediaURLList = "MediaUrlList"
        case url = "Url"
        case createdOn = "CreatedOn"
        case createdBy = "CreatedBy"
        case updatedOn = "UpdatedOn"
        case updatedBy = "UpdatedBy"
        case pricePercentDiscount = "PricePercentDiscount"
        case wishlistCount = "WishlistCount"
        case buyCount = "BuyCount"
        case viewCount = "ViewCount"
        case rating = "Rating"
        case isChecked
    }
    
    func productImage() -> String {
        return self.mediaURL.isEmptyOrNil ? "https://sternbergclinic.com.au/wp-content/uploads/2020/03/placeholder.png" : self.mediaURL!
    }
    
    func productImageFirst() -> String {
        if let items = self.mediaURLList {
            if items.count > 0 {
                return items[0]
            } else
            {
                return ""
            }
        }
        return self.mediaURL.isEmptyOrNil ? "https://sternbergclinic.com.au/wp-content/uploads/2020/03/placeholder.png" : self.mediaURL!
    }
}

enum OrganizationName: String, Codable {
    case bảoViệt = "Bảo Việt"
    case udemy = "Udemy"
}

enum ProductCategoryName: String, Codable {
    case góiVay = "Gói vay"
    case khoaHoc = "Khoa hoc"
}

enum Description: String, Codable {
    case pKhoáHoạc1P = "<p>Khoá hoạc 1</p>"
    case pTest1P = "<p>Test 1</p>"
}

// MARK: - ProductMediaList
//struct ProductMediaListNew: Codable {
//    var productMediaID, productID: Int?
//    var mediaID, type, status, createdOn: String?
//    var createdBy, updatedOn, updatedBy: String?
//    var mediaURL: String?
//
//    enum CodingKeys: String, CodingKey {
//        case productMediaID = "ProductMediaId"
//        case productID = "ProductId"
//        case mediaID = "MediaId"
//        case type = "Type"
//        case status = "Status"
//        case createdOn = "CreatedOn"
//        case createdBy = "CreatedBy"
//        case updatedOn = "UpdatedOn"
//        case updatedBy = "UpdatedBy"
//        case mediaURL = "MediaUrl"
//    }
//}
