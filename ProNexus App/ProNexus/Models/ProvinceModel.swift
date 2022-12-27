//
//  ProvinceModal.swift
//  ProNexus
//
//  Created by TUYEN on 11/23/21.
//

import Foundation

struct ProvinceListModel: Codable {
    var ok: Bool?
    var message: String?
    var results: [ProvinceModel]? = nil // list classification
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case results = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct ProvinceModel: Identifiable, Codable {
    var id = UUID()
    var name: String?
    var provinceId: Int?
    var districtId: Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case name = "Name"
        case provinceId = "ProvinceId"
        case districtId = "DistrictId"
    }
}
