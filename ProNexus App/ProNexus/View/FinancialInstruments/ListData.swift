//
//  ListData.swift
//  ProNexus
//
//  Created by TUYEN on 11/10/21.
//

import Foundation

struct ListItem: Identifiable {
    var id = UUID().uuidString
    var icon: String
    var title: String
    var subTitle: String
    var screenName: String
}


let listData = [
    ListItem(icon: "icon_item_1", title: "Kế hoạch tiết kiệm", subTitle: "Lập kế hoạch tiết kiệm", screenName: "tietkiem"),
    ListItem(icon: "icon_item_2", title: "Kế hoạch nghỉ hưu", subTitle: "Lập kế hoạch tài chính nghỉ hưu", screenName: "nghihuu"),
    ListItem(icon: "icon_item_3", title: "So sánh gói vay", subTitle: "So sánh các gói vay tiêu dùng", screenName: "sosanhgoivay"),
    ListItem(icon: "icon_item_4", title: "So sánh Mua nhà - Thuê nhà", subTitle: "So sánh dòng tiền theo từng phương án", screenName: "thuenha"),
    ListItem(icon: "icon_item_5", title: "Mua sắm tài sản lớn", subTitle: "Tính giá trị tài sản tối đa có thể mua", screenName: "muasam"),
]
