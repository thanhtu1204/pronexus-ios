//
//  CreateScheduleModel.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import Foundation

class CreateScheduleModel: ObservableObject {
    @Published var startDate: String?
    @Published var endDate : String?
    @Published var description: String?
    @Published var sessionList: [String]?
}
