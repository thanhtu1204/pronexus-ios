//
//  WithdrawalHistory.swift
//  ProNexus
//
//  Created by IMAC on 11/1/21.
//

import SwiftUI

// Profile Model And Sample Recents Msgs List...


struct ListMenu: Identifiable {
    var id = UUID().uuidString
    var icon: String
    var name: String
    var screen: String?
}


let listMenuProfile = [
    ListMenu(icon: "ic_profile", name: "Hồ sơ cá nhân", screen: "profile"),
    ListMenu(icon: "ic_connect", name: "Mời bạn bè", screen: "profile"),
    ListMenu(icon: "ic_setting", name: "Cài đặt", screen: "profile"),
    ListMenu(icon: "ic_support", name: "Trung tâm hỗ trợ", screen: "profile"),
    ListMenu(icon: "ic_policy", name: "Điều quản và pháp lý", screen: "profile"),
]

//struct ListItemMenu: Identifiable {
//    let id = UUID()
//    let name: String
//    let icon: String
//    var items: [ListItemMenu]?
//
//    // some example websites
//    static let apple = ListItemMenu(name: "Apple", icon: "1.circle")
//    static let bbc = ListItemMenu(name: "BBC", icon: "square.and.pencil")
//    static let swift = ListItemMenu(name: "Swift", icon: "bolt.fill")
//    static let twitter = ListItemMenu(name: "Twitter", icon: "mic")
//
//    // some example groups
//    static let example1 = ListItemMenu(name: "Hồ sơ cá nhân", icon: "ic_profile", items: [ListItemMenu.apple, ListItemMenu.bbc, ListItemMenu.swift, ListItemMenu.twitter])
//    static let example2 = ListItemMenu(name: "Mời bạn bè", icon: "ic_connect", items: [ListItemMenu.apple, ListItemMenu.bbc, ListItemMenu.swift, ListItemMenu.twitter])
//    static let example3 = ListItemMenu(name: "Cài đặt", icon: "ic_setting", items: [ListItemMenu.apple, ListItemMenu.bbc, ListItemMenu.swift, ListItemMenu.twitter])
//    static let example4 = ListItemMenu(name: "Trung tâm hỗ trợ", icon: "ic_support", items: [ListItemMenu.apple, ListItemMenu.bbc, ListItemMenu.swift, ListItemMenu.twitter])
//    static let example5 = ListItemMenu(name: "Điều quản và pháp lý", icon: "ic_policy", items: [ListItemMenu.apple, ListItemMenu.bbc, ListItemMenu.swift, ListItemMenu.twitter])
//}


struct Bookmarks: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var items: [Bookmarks]?

    // some example websites
    static let apple = Bookmarks(name: "Apple", icon: "1.circle")
    static let bbc = Bookmarks(name: "BBC", icon: "square.and.pencil")
    static let swift = Bookmarks(name: "Swift", icon: "bolt.fill")
    static let twitter = Bookmarks(name: "Twitter", icon: "mic")

    // some example groups
    static let example1 = Bookmarks(name: "Favorites", icon: "star", items: [Bookmarks.apple, Bookmarks.bbc, Bookmarks.swift, Bookmarks.twitter])
    static let example2 = Bookmarks(name: "Recent", icon: "timer", items: [Bookmarks.apple, Bookmarks.bbc, Bookmarks.swift, Bookmarks.twitter])
    static let example3 = Bookmarks(name: "Recommended", icon: "hand.thumbsup", items: [Bookmarks.apple, Bookmarks.bbc, Bookmarks.swift, Bookmarks.twitter])
    
    
}


