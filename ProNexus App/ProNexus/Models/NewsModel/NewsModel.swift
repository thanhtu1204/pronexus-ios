//
//  News.swift
//  ProNexus
//
//  Created by thanh cto on 28/10/2021.
//

import Foundation


// MARK: - NewsModel
struct NewsModel: Codable, Identifiable {
    var id = UUID()
    var title, description, slug, thumbnail: String?
    var authorID: String?
    var authorName, createdAt, content: String?
    var status, type: Int?
    var likePost: String?
    var keyword, tag: String?
    var categoryID: Int?
    var link: String?
    var postThumbnail: String?
    var viewCount: Int?
    var category: Category?

    enum CodingKeys: String, CodingKey {
        case title
        case description = "description"
        case slug, thumbnail
        case authorID = "author_id"
        case authorName = "author_name"
        case createdAt = "created_at"
        case content, status, type
        case likePost = "like_post"
        case keyword, tag
        case categoryID = "category_id"
        case link
        case postThumbnail = "post_thumbnail"
        case viewCount = "count_view"
        case category
    }
}

// MARK: - Category
struct Category: Codable {
    var id: Int?
    var name: String?
}

struct NewsListsModel: Codable {
    var currentPage: Int?
    var data: [NewsModel]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL, nextPageURL, path: String?
//    var perPage: Int?
    var prevPageURL: String?
    var to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
//        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}


struct NewsListsAdvisorModel: Codable {
    var currentPage: Int?
    var data: [NewsModel]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL, nextPageURL, path: String?
    var perPage: String? // điểm khác biệt vì api trả khác nhau
    var prevPageURL: String?
    var to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}


