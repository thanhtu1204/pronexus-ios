//
//  Banner.swift
//  ProNexus
//
//  Created by thanh cto on 11/10/2021.
//

import Foundation

class RegisterResponse: Codable {
    
    var message: String?
    var modalState: ModelState?
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case modalState = "ModelState"
    }
    
}

struct ModelState: Codable {
    var name: [String]?
    var email: [String]?
    var passwords: [String]?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case email = "Email"
        case passwords = "Passwords"
    }
}

