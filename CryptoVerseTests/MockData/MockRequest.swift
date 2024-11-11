//
//  MockRequest.swift
//  CryptoVerseTests
//
//  Created by Akhilesh Mishra on 11/11/24.
//

import Foundation
@testable import CryptoVerse

typealias Completion = (Data?, URLResponse?, Error?) -> Void

enum MockRequest {
  case cryptoList
}

extension MockRequest {
  
  //Identify request based on endpoint
  static func identifyRequest(request: URLRequest) -> MockRequest? {
    return .cryptoList
  }
  
  //Return success response
  func completionHandler(request: URLRequest, completion: Completion) {
    guard let method = request.httpMethod, let httpMethod = HTTPMethod(rawValue: method) else {
      fatalError("Unknown HTTPMethod Used.")
    }
    
    switch (self, httpMethod) {
    case (.cryptoList, .get):
      getCryptoList(request: request, statusCode: 200, completion: completion)
    default:
      fatalError("Request not handled yet.")
    }
  }
  
  //Return error response
  func badCompletionHandler(request: URLRequest, completion: Completion) {
    guard let method = request.httpMethod, let httpMethod = HTTPMethod(rawValue: method) else {
        fatalError("Unknown HTTPMethod Used.")
    }
    
    switch (self, httpMethod) {
    case (.cryptoList, .get):
        getBadCryptoList(request: request, statusCode: 400, completion: completion)
    default:
        fatalError("Request not handled yet.")
    }
  }
  
  // MARK: - Helper Functions
  private func getCryptoList(request: URLRequest, statusCode: Int, completion: Completion) {
      let path = Bundle.init(for: MockSession.self).path(forResource: "cryptoList", ofType: "json")
      guard let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe) else {
          let error = NSError(domain: "No stub data foubt", code: 0, userInfo: nil)
          completion(nil, nil, error)
          return
      }
      
      let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
      completion(data, response, nil)
  }
  
  private func getBadCryptoList(request: URLRequest, statusCode: Int, completion: Completion) {
      let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
      completion(nil, response, CryptoError("Server not reachable."))
  }

}
