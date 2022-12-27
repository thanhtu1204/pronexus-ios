//
//  ButtonViewModel.swift
//  ProNexus
//
//  Created by thanh cto on 13/11/2021.
//

import Foundation

class ButtonViewModel : Codable, Identifiable {
    var id : String?
    var name : String?
    
    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}
