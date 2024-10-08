//
//  NetworkModel.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import Foundation


final class NetworkModel: Codable {
    var totalResults: Int
    var fetchedResults: [ResultedFetch]
    var nextPage: String

    private enum CodingKeys: String, CodingKey {
        case totalResults = "totalResults"
        case fetchedResults = "results"
        case nextPage = "nextPage"
    }

    init(totalResults: Int, fetchedResults: [ResultedFetch], nextPage: String) {
        self.totalResults = totalResults
        self.fetchedResults = fetchedResults
        self.nextPage = nextPage
    }
}

final class ResultedFetch: Codable {
    var title: String
    var creator: [String]?
    var link: String
    var description: String?
    var pubDate: String
    var imageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case creator = "creator"
        case link = "link"
        case description = "description"
        case pubDate = "pubDate"
        case imageUrl = "image_url"
    }

    init(title: String, creator: [String]?, link: String, description: String?, pubDate: String, imageUrl: String?) {
        self.title = title
        self.creator = creator
        self.link = link
        self.description = description
        self.pubDate = pubDate
        self.imageUrl = imageUrl
    }
}
