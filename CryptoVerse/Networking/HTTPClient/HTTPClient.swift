//
//  HTTPClient.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

class HTTPClient {
  
  // MARK: typelalias
  typealias CompletionResult = (Result<Data?, CryptoError>) -> Void
  
  // MARK: Shared Instance
  static let shared = HTTPClient(session: URLSession.shared)
  
  // MARK: Private Properties
  private let session: URLSessionProtocol
  private var task: URLSessionDataTaskProtocol?
  private var completionResult: CompletionResult?
  
  // MARK: Initializer
  init(session: URLSessionProtocol) {
    self.session = session
  }
  
  // MARK: Data Task Helper
  func dataTask(_ request: RequestProtocol, completion: @escaping CompletionResult) {
    
    completionResult = completion
    var urlRequest = URLRequest(url: request.baseURL.appending(path: request.path),
                                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                timeoutInterval: Constants.Service.timeout)
    urlRequest.httpMethod = request.httpMethod.rawValue
    urlRequest.httpBody = request.httpBody
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
    task = session.dataTask(with: urlRequest) { data, response, error in
      // return error if there is any error in creating request
      if let error = error {
        self.completionResult(.failure(CryptoError(error.localizedDescription)))
        return
      }
      
      // check response
      if let response = response, response.isSuccess {
        if let data = data {
          self.completionResult(.success(data))
        }
        
        if response.httpStatusCode == 204 {
          self.completionResult(.success(nil))
        }
      } else {
        let genericErrorMessage = NSLocalizedString("Something went wrong!", comment: "")
        guard let data = data else {
          self.completionResult(.failure(CryptoError(genericErrorMessage)))
          return
        }
        
        do {
          let serverError = try JSONDecoder().decode(ServerError.self, from: data)
          self.completionResult(.failure(CryptoError(serverError.error ?? genericErrorMessage)))
        } catch {
          self.completionResult(.failure(CryptoError(genericErrorMessage)))
        }
      }
    }
    
    // resume task
    task?.resume()
  }
  
  func cancel() {
    task?.cancel()
  }
  
  // MARK: Private Helper Function
  private func completionResult(_ result: Result<Data?, CryptoError>) {
    DispatchQueue.main.async {
      self.completionResult?(result)
    }
  }
}
