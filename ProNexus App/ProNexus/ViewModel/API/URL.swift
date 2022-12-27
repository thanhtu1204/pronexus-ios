//
//  URL.swift
//  ProNexus
//
//  Created by thanh cto on 07/11/2021.
// https://newbedev.com/how-can-i-build-a-url-with-query-parameters-containing-multiple-values-for-the-same-key-in-swift

import Foundation


extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url!
    }
}
