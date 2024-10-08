//
//  NetworkService.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit


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
    var isPaginating: Bool { get }
    func fetchNews(page: String?, completion: @escaping (Result<NetworkModel, NetworkErrors>) -> Void)
    func fetchImage(imageUrl: String, completion: @escaping (Result<UIImage, NetworkErrors>) -> Void)
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

    func fetchNews(page: String?, completion: @escaping (Result<NetworkModel, NetworkErrors>) -> Void) {
        var urlString = ""
        if isPaginating {
            print("IS PAGINATING: \(isPaginating)")
            return
        }
        if let page = page {
            isPaginating = true
            urlString = "https://newsdata.io/api/1/latest?apikey=\(apiKey)&language=\(language)&page=\(page)"
        } else {
            urlString = "https://newsdata.io/api/1/latest?apikey=\(apiKey)&language=\(language)"
        }
        guard let url = URL(string: urlString) else { return }

        let urlRequest = URLRequest(url: url)

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

    func fetchImage(imageUrl: String, completion: @escaping (Result<UIImage, NetworkErrors>) -> Void) {
        guard let url = URL(string: imageUrl) else { return }
        let urlRequest = URLRequest(url: url)

        print("ImageURL: \(imageUrl)")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
                        guard let postImage = UIImage(data: data) else { return }
                        completion(.success(postImage))
                    }
                default:
                    self.isPaginating = false
                    completion(.failure(.unknownError))
                }
            }
        }.resume()
    }

}
