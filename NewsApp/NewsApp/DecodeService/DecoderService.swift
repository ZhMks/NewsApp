//
//  DecoderService.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import Foundation


protocol DecoderService: AnyObject {
    func decodeData(data: Data, completion: @escaping (Result<NetworkModel, Error>) -> Void)
}

final class DecoderServiceClass: DecoderService {

    func decodeData(data: Data, completion: @escaping (Result<NetworkModel, any Error>) -> Void) {
        let decoder = JSONDecoder()
        do {
           let networkModel = try decoder.decode(NetworkModel.self, from: data)
            completion(.success(networkModel))
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            completion(.failure(error))
        }
    }
    

}
