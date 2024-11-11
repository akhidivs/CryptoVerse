//
//  BadMockSession.swift
//  CryptoVerseTests
//
//  Created by Akhilesh Mishra on 11/11/24.
//

import Foundation
@testable import CryptoVerse

//BadMockSession will always return error or nil response
class BadMockSession: URLSessionProtocol {
  func dataTask(with request: URLRequest,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
      
    if let mockRequest =  MockRequest.identifyRequest(request: request) {
      mockRequest.badCompletionHandler(request: request, completion: completionHandler)
    }
    
    return MockDataTask()
  }
}
