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
            
            if let error = error {
                print("Error with fetching cat: \(error)")
                completionHandler(.failure(CatAPIError.noData))
            }
            
            //            if let httpResponse = response as? HTTPURLResponse,
            //                  (200...299).contains(httpResponse.statusCode) {
            //                print("Error with the response, unexpected status code: \(String(describing: response))")
            //                completionHandler(.failure(CatAPIError.httpsError))
            //                return
            //            }
            
            if let data = data {
                let cat = try? JSONDecoder().decode(Cat.self, from: data)
                completionHandler(.success(cat))
            }
        })
        task.resume()
    }
}

struct CatAPIError {
    static let noData = NSError(domain: "Server doesn't response.",
                                code: 1, userInfo: nil)
    static let httpsError = NSError(domain: "An HTTPS error occured.",
                                    code: 1, userInfo: nil)
    static let serverError = NSError(domain: "There's an error when the app wants to reach the server!",
                                     code: 1, userInfo: nil)
}
