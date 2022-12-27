//
//  Constants.swift
//  Demo Ecommerce
//
//  Created by thanh cto on 10/10/2021.
//

import Foundation

struct Constants {
    
        
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContenType: String {
        case json = "application/json"
        case form = "application/x-www-form-urlencoded"
    }
    
    enum registerType: String {
        case customer = "RegisterCustomer"
        case provider = "registerProvider"
    }
}

public enum AppointmentStatus: String {
    case Pending = "Pending"
    case InProgress = "InProgress"
    case Approve = "Approve"
    case Done = "Done"
    case Cancel = "Cancel"
}
