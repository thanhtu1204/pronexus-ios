//
//  ListMomentScheduleViewModel.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import Foundation

class ListMomentScheduleViewModel : Codable {
    var id : String?
    var name : String?
    
    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}
