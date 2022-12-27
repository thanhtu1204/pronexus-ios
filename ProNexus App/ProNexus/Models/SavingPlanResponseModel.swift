//
//  SavingPlanResponseModel.swift
//  ProNexus
//
//  Created by TUYEN on 12/10/21.
//

import Foundation
// MARK: - Hello
struct SavingPlanResponseModel: Codable {
    var ok: Bool?
    var message: String?
    var payload: Payload?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct Payload: Codable {
    var years: Int?
    var income: Double?
    var interest: Double?
    var investment: Double? // đầu tư ban đàu
    var cumulativeInvestment: Double? // đầu tư tích luỹ
    var accruedInterest: Double?
    var charts: [SavingChart]?

    enum CodingKeys: String, CodingKey {
        case years = "Years"
        case income = "Income"
        case interest = "Interest"
        case investment = "Investment"
        case cumulativeInvestment = "CumulativeInvestment"
        case accruedInterest = "AccruedInterest"
        case charts = "Charts"
    }
}

// MARK: - Chart
struct SavingChart: Codable, Identifiable {
    var id = UUID()
    
    var year: Int?
        
    var firstBalance, lastBalance, interest: Double?

    enum CodingKeys: String, CodingKey {
        case year = "Year"
        case firstBalance = "FirstBalance"
        case lastBalance = "LastBalance"
        case interest = "Interest"
    }
}
