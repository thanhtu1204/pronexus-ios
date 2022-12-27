//
//  NewsCategoryModel.swift
//  ProNexus
//
//  Created by thanh cto on 02/11/2021.
//

import Foundation

struct NewsCategoryModel: Codable, Identifiable {
    var id: Int?
    var name: String?
    var newsCategoryodelDescription: String?
    enum CodingKeys: String, CodingKey {
        case id, name
        case newsCategoryodelDescription = "description"
    }
}

struct NewsListCategories: Codable {
    var data: [NewsCategoryModel]?
}
