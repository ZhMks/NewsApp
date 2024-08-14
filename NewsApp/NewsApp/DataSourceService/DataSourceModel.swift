//
//  DataSourceModel.swift
//  NewsApp
//
//  Created by Максим Жуин on 14.08.2024.
//

import UIKit

struct MainNewsResponse {
    var totalNews: Int
    var nexPage: String
    var resultedFetch: [ResultedFetchResponse]
}

struct ResultedFetchResponse: Hashable {
    var title: String
    var creator: [String]?
    var link: String
    var description: String?
    var pubDate: String
    var imageURL: String?
}

