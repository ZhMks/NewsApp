//
//  NetworkService.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import Foundation


enum NetworkErrors: String, Error {
    case serverError
    case pageNotFound
    case accessError
    case unknownError

    var description: String {
        switch self {
        case .serverError:
            "Ошибка сервера"
        case .pageNotFound:
            "Страница не найдена"
        case .accessError:
            "Ошибка доступа"
        case .unknownError:
            "Неизвестная ошибка"
        }
    }
}


protocol NetworkService: AnyObject {
    func fetchNews(text: String?, page: String?, completion: @escaping (Result<NetworkModel, NetworkErrors>) -> Void)
}


final class NetworkServiceClass: NetworkService {
    
    // MARK: - Properties
    let apiKey = "pub_503541093ea10db129d8cd81cf0710f827413"

    var isPaginating = false

    var language: String {
        get {
            guard let preferredLanguage = Locale.preferredLanguages.first else { return "" }
            let language = preferredLanguage.replacingOccurrences(of: "-", with: ",")
            return language
        }
    }


    // MARK: - Funcs
    
    func fetchNews(text: String?, page: String?, completion: @escaping (Result<NetworkModel, NetworkErrors>) -> Void) {
        guard let url = createURL(text: text, page: page) else { return }
        let urlRequest = URLRequest(url: url)
        if isPaginating {
            isPaginating = true
        } else {
            URLSession.shared.dataTask(with: urlRequest)  { data, response, error in
                if let _ = error {
                    self.isPaginating = false
                    completion(.failure(.accessError))
                }

                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 403:
                        self.isPaginating = false
                        completion(.failure(.accessError))
                    case 404:
                        self.isPaginating = false
                        completion(.failure(.pageNotFound))
                    case 500:
                        self.isPaginating = false
                        completion(.failure(.serverError))
                    case 200:
                        if let data = data {
                            let decoder = DecoderServiceClass()
                            decoder.decodeData(data: data) { [weak self] result in
                                switch result {
                                case .success(let success):
                                    self?.isPaginating = false
                                    completion(.success(success))
                                case .failure(let failure):
                                    print(failure.localizedDescription)
                                    self?.isPaginating = false
                                    completion(.failure(.unknownError))
                                }
                            }
                        }
                    default:
                        self.isPaginating = false
                        completion(.failure(.unknownError))
                    }
                }
            }.resume()
        }
    }

    private func createURL(text: String?, page: String?) -> URL? {

        var urlString = "https://newsdata.io/api/1/latest?apikey=\(apiKey)&language=\(language)"

            if let text = text, !text.isEmpty {
                urlString += "&q=\(text)"
            }

            if let page = page, !page.isEmpty {
                urlString += "&page=\(page)"
            }

            return URL(string: urlString)
    }

}
