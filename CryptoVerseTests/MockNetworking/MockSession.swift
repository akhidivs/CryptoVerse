//
//  MockSession.swift
//  CryptoVerseTests
//
//  Created by Akhilesh Mishra on 11/11/24.
//

import Foundation
@testable import CryptoVerse

//MokeSession or Good MockSession always return success response
class MockSession: URLSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
      
    if let mockRequest =  MockRequest.identifyRequest(request: request) {
      mockRequest.completionHandler(request: request, completion: completionHandler)
    }
    
    return MockDataTask()
  }
}
