//
//  APIClient.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation

class ApiClient {
    let configuration: URLSessionConfiguration
    
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    func getCat(completionHandler: @escaping (Result<Cat?, Error>) -> ()) {
        let url = URL(string: "https://cat-fact.herokuapp.com/" + "facts/" + "random")!
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            let clientError = (400...499).contains(httpResponse.statusCode)
            let serverError = (500...599).contains(httpResponse.statusCode)
            
            if let error = error {
                completionHandler(.failure(error))
            } else if clientError {
                completionHandler(.failure(CatAPIError.clientError))
            } else if serverError {
                completionHandler(.failure(CatAPIError.serverError))
            } else if let data = data {
                let cat = try? JSONDecoder().decode(Cat.self, from: data)
                completionHandler(.success(cat))
            }
        })
        task.resume()
    }
}

struct CatAPIError: Error {
    static let noData = NSError(domain: "Server response is not valid.", code: 01, userInfo: nil)
    static let clientError = NSError(domain: "A HTTPS client error occured.", code: 02, userInfo: nil)
    static let serverError = NSError(domain: "A HTTPS server error occured.", code: 03, userInfo: nil)
}
