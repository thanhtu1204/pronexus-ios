//
//  MarketPlaceApiService.swift
//  ProNexus
//
//  Created by Tú Dev app on 17/11/2021.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults
import Networking
import PromiseKit

class MarketPlaceApiService: ObservableObject {
    // load danh sach provider
    let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
    let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error api"])
    
    @Published var loading = false
    @Published var productList = ProductListModel()
    @Published var categoryList = ProductCategoryList(payload: [])
    @Published var cartCount = "0"
    @ObservedObject var cartModel = CartHeaderModel()
    
    init() {
        loading = true
        if let token = Defaults.accessToken {
            networking.setAuthorizationHeader(token: token)
        }
    }
    
    // load danh muc
    func loadCategory(productCategoryId:String="",type:String="",status:String = "") -> Promise<ProductCategoryList> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_CATEGORY)")
        urlBuilder?.appendQueryItem(name: "ProductCategoryId", value: "\(productCategoryId)")
        urlBuilder?.appendQueryItem(name: "Type", value: "\(type)")
        urlBuilder?.appendQueryItem(name: "Status", value: "\(status)")
        
        
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            networking.get(url) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProductCategoryList.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        self.categoryList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProductCategoryList(payload: []))
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    func loadListProducts(page: Int = 1, size: Int = 50, categoryId: String = "" , type: String = "" ,keyword:String = "", status: String = "1", buyCount:String = "", isPromote: Bool = false) -> Promise<ProductListModel> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_PRODUCT)")
        urlBuilder?.appendQueryItem(name: "Type", value: "\(type)")
        urlBuilder?.appendQueryItem(name: "Status", value: "\(status)")
        urlBuilder?.appendQueryItem(name: "PageSize", value: "\(size)")
        urlBuilder?.appendQueryItem(name: "PageNumber", value: "\(page)")
        urlBuilder?.appendQueryItem(name: "Keyword", value: "\(keyword)")
        urlBuilder?.appendQueryItem(name: "ProductcategoryIdList", value: "\(categoryId)")
        urlBuilder?.appendQueryItem(name: "BuyCount", value: "\(buyCount)")
        urlBuilder?.appendQueryItem(name: "IsPromote", value: "\(isPromote)")
        
        let url = urlBuilder?.absoluteString ?? ""
        
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProductListModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        self.productList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProductListModel())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    // load danh sach provider
    
    func loadProducts() {
        guard let url = URL(string: "\(Production.BASE_URL_API)\(ApiRouter.GET_PRODUCT)?ProductcategoryId=&Status=&PageNumber=1&PageSize=50&Type=2&wishlist=&Keyword=") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if(Defaults.accessToken != nil) {
            request.addValue("Bearer \(Defaults.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request){ (data, _, _) in
            guard let data = data else { return }
            let rs = try! JSONDecoder().decode(ProductListModel.self, from: data)
            DispatchQueue.main.async {
                
                self.productList = rs
                print("loadClassificationList", self.productList)
                self.loading = false
                
            }
        }.resume()
    }
    
    
    
    func loadProductDetail(id: String = "") -> Promise<ProductDetailResponseModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_PRODUCT)/\(id)")
        
        let url = urlBuilder?.absoluteString ?? ""
        
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProductDetailResponseModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProductDetailResponseModel())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    
    //add product to cart
    func addToCart(parameters: [String: Any]) -> Promise<CommonResponseModel> {
        return Promise { seal in
            networking.post("\(ApiRouter.ADD_PRODUCT_TO_CART)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CommonResponseModel())
                    }
                case .failure(let response):
                    
                    let json = response.dictionaryBody
                    let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
        }
    }
    
    
    //get cart
    func loadCart() -> Promise<ProductListModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_CART)")
        
        let url = urlBuilder?.absoluteString ?? ""
        
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProductListModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        //update count cart
                        Defaults.cartCount = rs.payload?.count ?? 0
                        self.cartModel.saveCartCount(value: "\(rs.payload?.count ?? 0)") { String in
                            
                        }
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProductListModel())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
        
    }
    
    // create order
    
    func createOrder(parameters: [String: Any]) -> Promise<CreateOrderModelResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.CREATE_ORDER)", parameters: parameters) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CreateOrderModelResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CreateOrderModelResponse())
                    }
                case .failure(let response):
                    
                    let json = response.dictionaryBody
                    let rs = try! JSONDecoder().decode(CreateOrderModelResponse.self, from: response.data)
                    seal.fulfill(rs)
                    // Handle error
                }
            }
        }
    }
    
    func removeProductInCart(id: String) -> Promise<CommonResponseModel> {
        return Promise { seal in
            networking.delete("ProductCart/\(id)") { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                        
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CommonResponseModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    // tao thanh toán vnpay
    func postCreatePaymentVnPay(parameters: [String: Any]) -> Promise<CreatePaymentVnPayResponse> {
        return Promise { seal in
            networking.post("\(ApiRouter.POST_CREATE_PAYMENT_VNPAY)", parameters: parameters) { result in
                self.loading = false
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CreatePaymentVnPayResponse.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CreatePaymentVnPayResponse())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    // thêm sản phẩm yêu thích
    func addFavoriteProduct(parameters: [String: Any]) -> Promise<CommonResponseModel> {
        return Promise { seal in
            networking.post("\(ApiRouter.ADD_FAVORITE_PRODUCT)", parameterType: .json, parameters: parameters) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        do {
                        } catch {
                            seal.reject(error)
                        }
                    } else
                    {
                        seal.reject(self.error)
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
        }
    }
    // xoá sản phẩm yêu thích
    func removeFavoriteProduct(id: String) -> Promise<CommonResponseModel> {
        return Promise { seal in
            networking.delete("\(ApiRouter.REMOVE_FAVORITE_PRODUCT)/\(id)") { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                    } else
                    {
                        seal.fulfill(CommonResponseModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
        }
    }
    
    // load danh sách sản phẩm yêu thích
    func loadFavoriteProducts() -> Promise<ProductListModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_FAVORITE_PRODUCT)")
        let url = urlBuilder?.absoluteString ?? ""
        
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(ProductListModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        self.productList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(ProductListModel())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
        }
    }
    
    // kiểm tra xem sản phẩm này đã nằm trong list yêu thích hay chưa
    func checkProductFavorite(id: String) -> Promise<CommonResponseModel> {
        let urlBuilder = URL(string: "ProductFavorite/\(id)/username")
        let url = urlBuilder?.absoluteString ?? ""
        
        return Promise { seal in
            networking.get(url) { result in
                self.loading = false
                
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(CommonResponseModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(CommonResponseModel())
                    }
                case .failure(let response):
                    
                    seal.reject(response.error)
                    // Handle error
                }
            }
        }
    }
    
    
}
