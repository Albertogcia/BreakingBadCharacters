//
//  SessionAPI.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

final class SessionAPI {
    
    var session: URLSession
    
    init(){
        let configuration = URLSessionConfiguration.default
        self.session =  URLSession(configuration: configuration)
    }
    
    convenience init(session: URLSession){
        self.init()
        self.session = session
    }

    func send<T: APIRequest>(request: T, completion: @escaping (Result<T.Response?, Error>) -> ()) {
        let request = request.requestWithBaseUrl()

        let task = session.dataTask(with: request) { data, response, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                let domainError = NSError(domain: "request", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "ResponseError"])
                DispatchQueue.main.async {
                    completion(.failure(domainError))
                }
                return
            }

            if let data = data, !data.isEmpty {
                do {
                    let model = try JSONDecoder().decode(T.Response.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }

            } else {
                DispatchQueue.main.async {
                    completion(.success(nil))
                }
            }
        }
        task.resume()
    }
}
