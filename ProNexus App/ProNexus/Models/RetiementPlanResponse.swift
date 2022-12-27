//
//  RetiementOlanResponseModel.swift
//  ProNexus
//
//  Created by TUYEN on 12/8/21.
//

import Foundation

struct RetiementPlanResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: RetiementPlan?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct RetiementPlan: Codable {
    var retirementAge: Int?
    var extraSavings: Double?
    var income: Double?
    var percentOfIncome: Double?
    var retirementAmount: Double?
    var charts: [Chart]?

    enum CodingKeys: String, CodingKey {
        case retirementAge = "RetirementAge"
        case extraSavings = "ExtraSavings"
        case income = "Income"
        case percentOfIncome = "PercentOfIncome"
        case retirementAmount = "RetirementAmount"
        case charts = "Charts"
    }
}

// MARK: - Chart
struct Chart: Codable, Identifiable {
    var id = UUID()
    var age: Int?
    var firstBalance, lastBalance: Double?
    var save, retirementIncome: Int?
    var interest: Double?

    enum CodingKeys: String, CodingKey {
//        case id = "Id"
        case age = "Age"
        case firstBalance = "FirstBalance"
        case lastBalance = "LastBalance"
        case save = "Save"
        case retirementIncome = "RetirementIncome"
        case interest = "Interest"
    }
}
