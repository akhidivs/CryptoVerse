//
//  URLSessionExtension.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

extension URLSession: URLSessionProtocol {
  
  func dataTask(with request: URLRequest,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
    let task = dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    return task as URLSessionDataTaskProtocol
  }
  
}
