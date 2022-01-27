//
//  NetworkManager.swift
//  JSONManualParser
//
//  Created by Андрей Евдокимов on 27.01.2022.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(from url: String, completion: @escaping(Result<[String: Any], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let convertedValue = value as? [String: Any] else { return }

                    completion(.success(convertedValue))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
