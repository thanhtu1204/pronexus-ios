//
//  LoanPackageModel.swift
//  ProNexus
//
//  Created by TUYEN on 12/10/21.
//

import Foundation
struct LoanPackageModelResponse: Codable {
    var ok: Bool?
    var message: String?
    var payload: LoanPackage?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - Payload
struct LoanPackage: Codable {
    
    var khoanVay: Double?
    var kyHan: Int?
    var laiSuatDuNo: Int?
    var laiSuatDanhNghia: Double?
    var laiSuatThapNhat: Double?
    var loan1: [Loan]?
    var loan2: [Loan]?
    var loan3: [Loan]?

    enum CodingKeys: String, CodingKey {
        case loan1 = "Loan1"
        case loan2 = "Loan2"
        case loan3 = "Loan3"
        case kyHan = "KyHan"
        case khoanVay = "KhoanVay"
        case laiSuatDuNo = "LaiSuatDuNo"
        case laiSuatDanhNghia = "LaiSuatDanhNghia"
        case laiSuatThapNhat = "LaiSuatThapNhat"
    }
}

// MARK: - Loan1
struct Loan: Codable, Identifiable {
    var id = UUID()
    
    var months:  Int?
    var principal, interest, debt: Double?
    var amount: Double?

    enum CodingKeys: String, CodingKey {
        case months = "Months"
        case principal = "Principal"
        case interest = "Interest"
        case debt = "Debt"
        case amount = "Amount"
    }
}
