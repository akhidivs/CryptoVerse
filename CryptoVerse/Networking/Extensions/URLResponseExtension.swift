//
//  URLResponseExtension.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

extension URLResponse {
  
  var isSuccess: Bool {
    return httpStatusCode >= 200 && httpStatusCode < 300
  }
  
  var httpStatusCode: Int {
    guard let statusCode = (self as? HTTPURLResponse)?.statusCode else {
      return 0
    }
    return statusCode
  }
  
}
