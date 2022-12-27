//
//  ResponRegisterAdvisor.swift
//  ProNexus
//
//  Created by TUYEN on 11/11/21.
//

import Foundation

class ResponseRegisterAdvisor: Codable {
    
    var message: String?
//    var modalState: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
//        case modalState = "ModelState"
    }
    
}
