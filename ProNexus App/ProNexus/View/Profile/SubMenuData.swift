//
//  SubMenuData.swift
//  ProNexus
//
//  Created by TUYEN on 11/10/21.
//

import Foundation

struct SubMenu: Identifiable, Hashable {
    let id: Int
    let label: String
    let menu1: String
    let menu2: String
    let menu3: String

    
    static func subMenu() -> [SubMenu] { (1..<2).map(SubMenu.fixture) }
    
    private static func fixture(_ id: Int) -> SubMenu {
        SubMenu(
            id: id,
            label: "Trung tâm hỗ trợ",
            menu1: "Về ProNexus",
            menu2: "Hướng dẫn sử dụng",
            menu3: "Câu hỏi thường gặp"
        )
    }
}
