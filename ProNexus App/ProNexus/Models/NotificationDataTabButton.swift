//
//  NotificationDataTabButton.swift
//  ProNexus
//
//  Created by IMAC on 10/31/21.
//

import SwiftUI


// Model Data...

struct BagModel: Identifiable {
    var id = UUID().uuidString
    var image : String
    var title: String
    var price: String
}

var bags = [

    BagModel(image: "bag1", title: "Office Bag", price: "$234"),
    BagModel(image: "bag5", title: "Stylus Bag", price: "$434"),
    BagModel(image: "bag6", title: "Round Belt", price: "$134"),
    BagModel(image: "bag2", title: "Belt Bag", price: "$294"),
    BagModel(image: "bag3", title: "Hang Top", price: "$204"),
    BagModel(image: "bag4", title: "Old Fashion", price: "$334")

]

// For Top SCrolling Tab Buttons....
var scroll_Tabs = ["Mới nhất","Lịch hẹn","Giao dịch","Ưu đãi"]

//var scroll_Tabs = ["Mới nhất","Lịch hẹn","Giao dịch"]
