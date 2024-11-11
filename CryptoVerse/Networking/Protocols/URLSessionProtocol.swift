//
//  URLSessionProtocol.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(with request: URLRequest,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
