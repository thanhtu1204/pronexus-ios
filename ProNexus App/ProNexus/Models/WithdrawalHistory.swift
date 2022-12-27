//
//  WithdrawalHistory.swift
//  ProNexus
//
//  Created by IMAC on 11/1/21.
//

import SwiftUI

// Profile Model And Sample Recents Msgs List...

struct WithdrawalHistory: Identifiable {
    var id = UUID().uuidString
    var name: String
    var profile: String
    var lastMsg: String
    var time: String
    var status: String
    var price: String
    var userName: String
    var title: String
}

struct Schedule: Identifiable {
    var id = UUID().uuidString
    var date: String
    var time: String
}

let recentsHistory = [
    
    WithdrawalHistory(name: "Rút tiền", profile: "pic1", lastMsg: "Hi Kavsoft !!!", time: "10:25", status: "Đang chờ", price: "1.000.000", userName: "Nguyễn Văn Bảo", title: "Cố vấn tài chính"),
    WithdrawalHistory(name: "Rút tiền", profile: "pic2", lastMsg: "What's Up 🥳🥳🥳", time: "11:25", status: "Đang chờ", price: "1.000.000", userName: "Nguyễn Văn Bảo", title: "Cố vấn tài chính"),
    WithdrawalHistory(name: "Rút tiền", profile: "pic3", lastMsg: "Need to Record Doumentation", time: "10:25", status: "Đang chờ", price: "1.000.000", userName: "Nguyễn Văn Bảo", title: "Cố vấn tài chính"),
    WithdrawalHistory(name: "Rút tiền", profile: "pic4", lastMsg: "Simply Sitting", time: "10:25", status: "Đã duyệt", price: "1.000.000", userName: "Nguyễn Văn Bảo", title: "Cố vấn tài chính"),
    WithdrawalHistory(name: "Rút tiền", profile: "pic5", lastMsg: "Lying :(((((", time: "10:25", status: "Đang chờ", price: "1.000.000", userName: "Nguyễn Văn Bảo", title: "Cố vấn tài chính"),
    WithdrawalHistory(name: "Rút tiền", profile: "pic6", lastMsg: "No March Event🥲", time: "06:25", status: "Đang chờ", price: "1.000.000", userName: "Nguyễn Văn Bảo", title: "Cố vấn tài chính"),
]

let recentsSchedule = [
    Schedule(date: "Ngày 22/10/2022", time: "Buổi sáng  |  Buổi chiều"),
    Schedule(date: "Ngày 22/10/2022", time: "Buổi sáng  |  Buổi chiều"),
    Schedule(date: "Ngày 22/10/2022", time: "Buổi sáng  |  Buổi chiều"),
    Schedule(date: "Ngày 22/10/2022", time: "Buổi sáng  |  Buổi chiều"),
]
