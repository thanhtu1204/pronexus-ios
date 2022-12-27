//
//  BannerService.swift
//  ProNexus
//
//  Created by thanh cto on 07/11/2021.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults
import Networking
import PromiseKit

class BannerService: ObservableObject {
    
    let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
    @Published var bannerList = BannersResponse()
    @Published var bannerModel = BannerModel()
    @Published var loading = false
    
    init() {
        loading = true
        if let token = Defaults.accessToken {
           networking.setAuthorizationHeader(token: token)
        }
    }
    
    
    // load danh sach provider
    func loadListBanners(page: Int = 1, size: Int = 15) -> Promise<BannersResponse> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_BANNER)")
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                            let rs = try! JSONDecoder().decode(BannersResponse.self, from: response.data)
                            // Do something with JSON, you can also get arrayBody
                            self.bannerList = rs
                            seal.fulfill(rs)
                        } catch {
                            let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error api"])
                            seal.reject(error)
                        }

                    } else
                    {
                        seal.fulfill(BannersResponse())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
}
