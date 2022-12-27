//
//  TabSettingModel.swift.swift
//  ProNexus
//
//  Created by thanh cto on 04/11/2021.
//

import SwiftUI
import MapKit

class TabViewSettingModel: ObservableObject {
    
    // Tab Bar...
    @Published var currentTab: TabEnum = .Home
    @Published var isShowAlert: Bool = false
    @Published var AlertMessage: String = ""
    
    init(currentTab: TabEnum)
    {
        self.currentTab = currentTab
    }
}


enum TabEnum: String{
    case Home = "home"
    case Calendar = "calendar"
    case Message = "message"
    case Setting = "setting"
    case Advisor = "advisor"
}
