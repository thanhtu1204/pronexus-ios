//
//  BankListModel.swift
//  ProNexus
//
//  Created by Tú Dev app on 07/11/2021.
//
import Foundation

// MARK: - Bank
struct BankListModel: Codable {
    var data: [BankVnpayModel]?
}

// MARK: - Datum
struct BankVnpayModel: Codable ,Identifiable{
    var id = UUID()
    var no : String?
    var code: String?
    var logo: String?
    var bank: String?

    enum CodingKeys: String, CodingKey {
        case no = "id"
        case code = "code"
        case logo = "logo "
        case bank = "bank"
    }
}
