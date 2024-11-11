//
//  RequestProtocol.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

public typealias HTTPHeaders = [String: String]

protocol RequestProtocol {
  var baseURL: URL { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
  var httpBody: Data? { get }
  var httpHeaders: HTTPHeaders? { get }
}
