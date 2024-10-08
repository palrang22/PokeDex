//
//  NetworkManager.swift
//  PokeDex
//
//  Created by 김승희 on 8/5/24.
//

import UIKit
import Alamofire
import RxSwift

enum NetworkError : Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let session = URLSession(configuration: .default)
            
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let data = data,
                      let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodedData))
                } catch {
                    observer(.failure(NetworkError.decodingFail))
                }
            }.resume()
            return Disposables.create()
        }
    }
    
    func fetchImage(url: URL) -> Single<UIImage> {
        return Single.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    single(.failure(NetworkError.dataFetchFail))
                    return
                }
                
                single(.success(image))
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
