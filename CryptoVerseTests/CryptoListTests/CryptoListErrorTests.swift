//
//  CryptoListErrorTests.swift
//  CryptoVerseTests
//
//  Created by Akhilesh Mishra on 11/11/24.
//

import XCTest
@testable import CryptoVerse

class CryptoListErrorTests: XCTestCase {

  var cryptoListViewModel: CryptoListViewModel!
  
  override func setUp() {
    let session = BadMockSession()
    let client = HTTPClient(session: session)
    cryptoListViewModel = CryptoListViewModel(client: client)
  }
  
  override func tearDown() {
      
  }
  
  func testCryptoAPIFailedResponse() {
    let expectation = self.expectation(description: "No error return by API.")
      
    cryptoListViewModel.error.bind { (error) in
      if error != nil {
        expectation.fulfill()
      }
    }
      
    cryptoListViewModel.getCryptoList()
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
}
