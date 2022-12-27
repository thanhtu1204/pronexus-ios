//
//  ClassificationApiService.swift
//  ProNexus
//


import Foundation
import SwiftUI
import SwiftyUserDefaults
import PromiseKit
import Networking


class ClassificationApiService: ObservableObject {
    
    let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
    let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error api"])
    
    @Published var classification = ClassificationModel()
    @Published var loading = false

    init() {
        loading = true
        if let token = Defaults.accessToken {
           networking.setAuthorizationHeader(token: token)
        }
    }
        
        
    // lấy toàn bộ danh sách danh mục provider
    func loadClassificationList() -> Promise<ClassificationListModel> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_CLASSIFICATION)")
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ClassificationListModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ClassificationListModel(results: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    
    
    
}
