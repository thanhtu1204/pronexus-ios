//
//  BoardingScreen.swift
//  BoardingScreen
//
//  Created by Balaji on 27/08/21.
//

import SwiftUI

struct BoardingScreen: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
}


// Since image name and BG color name are same....

// Sample Model SCreens....
var boardingScreens: [BoardingScreen] = [

    BoardingScreen(image: "bg_onboarding1", title: "Kết nối", description: "Tìm kiếm và đặt lịch hẹn dễ dàng"),
    BoardingScreen(image: "bg_onboarding2", title: "Công cụ", description: "Sử dụng bộ công cụ tài chính miễn phí trọn đời"),
    BoardingScreen(image: "bg_onboarding3", title: "Market Place", description: "Lựa chọn và mua sắm đa dạng sản phẩm tài chính phù hợp"),
]
