//
//  BankListApiService.swift
//  ProNexus
//
//  Created by Tú Dev app on 07/11/2021.
//

import Foundation
import Foundation
import SwiftUI
import SwiftyUserDefaults
import PromiseKit
import Networking

class BankListApiService: ObservableObject {
    let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
    let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error api"])
    
    @Published var loading = false
    @Published var bankList = BankListModel(data: [])
    @Published var selectedBankCode: String?
    
    init() {
        loading = true
    }
    
    // get danh sach ngan hang
    func loadBankList() {
        guard let url = URL(string: "https://api.npoint.io/62b62b43986cef716893") else { return }
        URLSession.shared.dataTask(with: url){ (data, _, _) in
            guard let data = data else { return }
            let rs = try! JSONDecoder().decode(BankListModel.self, from: data)
            DispatchQueue.main.async {
                
                self.bankList = rs
                self.loading = false
                
            }
        }.resume()
    }
    
    func loadBanks() -> Promise<BankListModel> {
        let networking = Networking(baseURL: "https://api.npoint.io/")
        _ = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error api"])
        
        let urlBuilder = URL(string: "62b62b43986cef716893")
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    let rs = try! JSONDecoder().decode(BankListModel.self, from: response.data)
                    // Do something with JSON, you can also get arrayBody
                    self.bankList = rs
                    seal.fulfill(rs)
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
}
