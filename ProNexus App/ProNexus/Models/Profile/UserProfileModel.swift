//
//  UserProfileModel.swift
//  ProNexus
//
//  Created by thanh cto on 05/11/2021.
//

import Foundation
import SwiftyUserDefaults

enum UserRole: String {
    case advisor = "Advisor"
    case user = "Customer"
}
    
struct UserProfileModel: Codable, DefaultsSerializable {
    // dang nhap thanh cong
    var accessToken, tokenType: String?
    var expiresIn: Int?
    var userName: String?
    var customerID: String?
    var providerID: String?
    var role: String?
    var fullName: String?
    var firstName: String?
    var lastName: String?
    var userEmail: String?
    var profileImageURL: String?
    var issued, expires: String?
    
    // dang nhap fail
    var error: String?
    var errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case userName
        case customerID = "CustomerId"
        case providerID = "ProviderId"
        case role = "Role"
        case userEmail = "UserEmail"
        case fullName = "FullName"
        case firstName = "FirstName"
        case lastName = "LastName"
        case profileImageURL = "ProfileImageURL"
        case issued = ".issued"
        case expires = ".expires"
        
        case error = "error" // trạng thái khi mà đăng nhập fail
        case errorMessage = "error_description"
    }
    
    func getIdByRole() -> String {
        if self.role == UserRole.advisor.rawValue
        {
            return self.providerID ?? ""
        }
        return self.customerID ?? ""
    }
}
