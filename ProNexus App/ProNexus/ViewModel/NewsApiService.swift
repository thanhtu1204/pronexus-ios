//
//  NewsApiService.swift
//  ProNexus
//
//  Created by thanh cto on 28/10/2021.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults
import Networking
import PromiseKit

class NewsApiService: ObservableObject {
    
    let networking = Networking(baseURL: "\(Production.BASE_URL_API)")
    let apiNews = Networking(baseURL: "\(Production.BASE_URL_API2)")
    let error = NSError(domain: "com.pronexus", code: 0, userInfo: [NSLocalizedDescriptionKey: "error api"])
    
    @Published var newsList = NewsListsModel(data: [])
    @Published var newsListFeature = NewsListsModel(data: [])
    @Published var newsCategories = NewsListCategories(data: [])
    @Published var newsListAdvisor = NewsListsAdvisorModel(data: [])
    @Published var expertiseArticleList = NewsListsModel(data: []) // danh sach bai viet chuyen gia
    @Published var loading = false
    
    init() {
        loading = true
    }
    
    
    // load kien thuc
    func loadNewsDetail(key: String) -> Promise<NewsModel> {
        var urlBuilder = URL(string: "\(ApiRouter.GET_CATEGORY_NEWS_BY_ID)/\(key)")
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            apiNews.get(url) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(NewsModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(NewsModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
    
    
    // danh sach bai viet noi bat
    func loadNewsFeature() {
        
        guard let url = URL(string: "\(Production.BASE_URL_API2)\(ApiRouter.GET_FEATURED_NEWS)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){ (data, _, _) in
            guard let data = data else { return }
            let rs = try! JSONDecoder().decode(NewsListsModel.self, from: data)
            DispatchQueue.main.async {
                
                self.newsListFeature = rs
                print("Ds bai viet noi bat", self.newsListFeature)
                self.loading = false
                
            }
        }.resume()
    }
    
    // danh sach bai viet cua co van
    func loadNewsAdvisor() {
        
        guard let url = URL(string: "\(Production.BASE_URL_API2)\(ApiRouter.GET_NEWS_BY_ADVISOR)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){ (data, _, _) in
            guard let data = data else { return }
            let rs = try! JSONDecoder().decode(NewsListsAdvisorModel.self, from: data)
            DispatchQueue.main.async {
                
                self.newsListAdvisor = rs
                print("Ds bai viet cua co van", self.newsListAdvisor)
                self.loading = false
                
            }
        }.resume()
    }
    
    // danh sach cate của tin tức
    func loadCategories() {
        
        guard let url = URL(string: "\(Production.BASE_URL_API2)\(ApiRouter.GET_CATEGORY_NEWS)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){ (data, _, _) in
            guard let data = data else { return }
            let rs = try! JSONDecoder().decode([NewsCategoryModel].self, from: data)
            DispatchQueue.main.async {
                
                self.newsCategories.data = rs
                print("Danh muc tin tuc", self.newsCategories)
                self.loading = false
                
            }
        }.resume()
    }
    
    // load tin tuc theo cate ID
    func loadNewsByCatID(id: String = "") {
        // neu không truyền id thì là load all
        var urlText = "\(Production.BASE_URL_API2)\(ApiRouter.GET_CATEGORY_NEWS_BY_ID)?limit=30"
        if id != "" {
            urlText = urlText + "&category_id=" + id
        }
        guard let url = URL(string: urlText) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){ (data, _, _) in
            guard let data = data else { return }
            let rs = try! JSONDecoder().decode(NewsListsModel.self, from: data)
            DispatchQueue.main.async {
                
                self.newsList = rs
                print("Bai viet theo danh muc", self.newsList)
                self.loading = false
                
            }
        }.resume()
    }
    
    // load kien thuc
    func loadExpertiseArticleList(page: Int = 1, size: Int = 15) -> Promise<NewsListsModel> {
        let urlBuilder = URL(string: "\(ApiRouter.GET_EXPERTISE_ARTICLE)")
        let url = urlBuilder?.absoluteString ?? ""
        return Promise { seal in
            apiNews.get(url) { result in
                switch result {
                case .success(let response):
                    if response.dictionaryBody.count > 0
                    {
                        let rs = try! JSONDecoder().decode(NewsListsModel.self, from: response.data)
                        // Do something with JSON, you can also get arrayBody
                        self.expertiseArticleList = rs
                        seal.fulfill(rs)
                    } else
                    {
                        seal.fulfill(NewsListsModel())
                    }
                case .failure(let response):
                    seal.reject(response.error)
                    // Handle error
                }
            }
            
        }
    }
}
