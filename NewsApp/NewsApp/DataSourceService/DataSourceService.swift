//
//  DataSourceService.swift
//  NewsApp
//
//  Created by Максим Жуин on 13.08.2024.
//

import UIKit


final class DataSourceService {

    var mainNewsArray: [MainNewsResponse]?

    let networkService: NetworkService


    init(networkService: NetworkService, mainNewsArray: [MainNewsResponse] = []) {
        self.networkService = networkService
        self.mainNewsArray = mainNewsArray
    }

    func fetchNews(page: String?, completion: @escaping(Result<[MainNewsResponse], Error>) -> Void) {

        networkService.fetchNews(page: page) { [weak self] result in
            switch result {
            case .success(let networkNews):
                let resultedFetchResponseArray: [ResultedFetchResponse] = networkNews.fetchedResults.map { model in
                    ResultedFetchResponse(title: model.title,
                                          creator: model.creator,
                                          link: model.link,
                                          description: model.description,
                                          pubDate: model.pubDate,
                                          imageURL: model.imageUrl)
                }
                let mainNewsResponse = MainNewsResponse(totalNews: networkNews.totalResults, nexPage: networkNews.nextPage, resultedFetch: resultedFetchResponseArray)
                self?.mainNewsArray?.append(mainNewsResponse)
                completion(.success(self?.mainNewsArray ?? []))
            case .failure(let failure):
                print(failure.localizedDescription)
                completion(.failure(failure))
            }
        }
    }
}
