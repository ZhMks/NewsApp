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
    func fetchSpecificNews(text: String, completion: @escaping (Result<NetworkModel, NetworkErrors>) -> Void)
}


final class NetworkServiceClass: NetworkService {
    
    let apiKey = "pub_503541093ea10db129d8cd81cf0710f827413"

    func fetchSpecificNews(text: String, completion: @escaping (Result<NetworkModel, NetworkErrors>) -> Void) {
        guard let fetchedUrl = URL(string: "https://newsdata.io/api/1/news?apikey=\(apiKey)&language=ru,RU&q=\(text)") else { return }
        let urlRequest = URLRequest(url: fetchedUrl)
        URLSession.shared.dataTask(with: urlRequest)  { data, response, error in

            if let _ = error {
                completion(.failure(.accessError))
            }

            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 403:
                    completion(.failure(.accessError))
                case 404:
                    completion(.failure(.pageNotFound))
                case 500:
                    completion(.failure(.serverError))
                case 200:
                    if let data = data {
                        let decoder = DecoderServiceClass()
                        decoder.decodeData(data: data) { result in
                            switch result {
                            case .success(let success):
                                completion(.success(success))
                            case .failure(let failure):
                                print(failure.localizedDescription)
                                completion(.failure(.unknownError))
                            }
                        }
                    }
                default:
                    completion(.failure(.unknownError))
                }
            }

        }.resume()
    }


    func fetchNews(completion: @escaping(Result<NetworkModel, NetworkErrors>) -> Void) {
        guard let fetchedUrl = URL(string: "https://newsdata.io/api/1/news?apikey=\(apiKey)&language=ru,RU") else { return }
        let urlRequest = URLRequest(url: fetchedUrl)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(.accessError))
            }

            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 403:
                    completion(.failure(.accessError))
                case 404:
                    completion(.failure(.pageNotFound))
                case 500:
                    completion(.failure(.serverError))
                case 200:
                    if let data = data {
                        let decoder = DecoderServiceClass()
                        decoder.decodeData(data: data) { result in
                            switch result {
                            case .success(let success):
                                completion(.success(success))
                            case .failure(let failure):
                                print(failure.localizedDescription)
                                completion(.failure(.unknownError))
                            }
                        }
                    }
                default:
                    completion(.failure(.unknownError))
                }
            }

        }.resume()
    }
}
