//
//  CryptoError.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

typealias CryptoErrorHandler = (CryptoError?) -> Void

struct CryptoError: Error {
  
  var localizedDescription: String
  init(_ localizedDescription: String) {
    self.localizedDescription = localizedDescription
  }
  
}
