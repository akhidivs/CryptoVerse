//
//  CryptoService.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

enum CryptoAPI {
  case getCryptoList
}

extension CryptoAPI: RequestProtocol {
  
  // Set Base URL
  var baseURL: URL {
    guard let url = URL(string: Constants.Service.baseURL) else {
      fatalError("Base URL could not be configured")
    }
    return url
  }
  
  // return endpoint for Crypto APIs
  var path: String {
    return ""
  }
  
  // return http method
  var httpMethod: HTTPMethod {
    return .get
  }
  
  // return http body
  var httpBody: Data? {
    return nil
  }
  
  // return API specific headers
  var httpHeaders: HTTPHeaders? {
    return nil
  }
}

