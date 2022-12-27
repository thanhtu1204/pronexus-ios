//
//  AppUtils.swift
//  ProNexus
//
//  Created by thanh cto on 15/11/2021.
//

import Foundation
import SwiftUI

class AppUtils {
    
    //show Alert
    static func showAlert(text: String, type: String = "success") {
        let messages = ["msg": text, "type": type]
        NotificationCenter.default.post(name: .didAlertMessage, object: nil, userInfo: messages)
    }
    
    static func translateAppointmentOrderStatus(text: String) -> String {
        var status = ""
        if text == AppointmentStatus.Pending.rawValue {
            status = "Chờ xác nhận"
        } else if text == AppointmentStatus.Approve.rawValue {
            status = "Sắp diễn ra"
        } else if text == AppointmentStatus.Done.rawValue {
            status = "Đã kết thúc"
        } else if text == AppointmentStatus.Cancel.rawValue {
            status = "Từ chối"
        } else if text == AppointmentStatus.InProgress.rawValue {
            status = "Đang diễn ra"
        } else {
            status = text
        }
        return status
    }
    
    static func translateStatusMoment(text: String) -> String {
        
        var status = ""
        if text == "Morning" {
            status = "Sáng"
        } else if text == "Afternoon" {
            status = "Chiều"
        } else if text == "Evening" {
            status = "Tối"
        } else if text == "AllDay" {
            status = "Cả ngày"
        } else {
            status = text
        }
        return status
    }
}
