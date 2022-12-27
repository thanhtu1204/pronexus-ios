//
//  Configs.swift
//  ProNexus
//
//  Created by thanh cto on 14/10/2021.
//

import Foundation

struct Production {

    static let BASE_URL: String = "http://api2.pronexus.com.vn/" // Thay thế bằng Base url mà bạn sử dụng ở đây
    static let BASE_URL_API =  BASE_URL + "api/"
    static let BASE_URL2: String = "http://pronexus.com.vn/" // Thay thế bằng Base url mà bạn sử dụng ở đây
    static let BASE_URL_API2 =  BASE_URL2 + "/api/"
    
}

enum NetworkErrorType {
    case API_ERROR
    case HTTP_ERROR
}
