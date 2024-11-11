//
//  CryptoListTests.swift
//  CryptoVerseTests
//
//  Created by Akhilesh Mishra on 11/11/24.
//

import XCTest
@testable import CryptoVerse

class CryptoListTests: XCTestCase {

  var cryptoListViewModel: CryptoListViewModel!
  
  override func setUp() {
    let session = MockSession()
    let client = HTTPClient(session: session)
    cryptoListViewModel = CryptoListViewModel(client: client)
  }

  override func tearDown() {
      
  }

  func testCryptoListTitle() {
      XCTAssert(cryptoListViewModel.title == "COIN", "Crypto list title mismatch.")
  }
  
  func testCryptListAPISuccessResponse() {
    let expectation = self.expectation(description: "No response received from crypto list API.")
    
    cryptoListViewModel.error.bind { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
    
    cryptoListViewModel.cryptoCoins.bind { (cryptoList) in
      if cryptoList != nil {
        expectation.fulfill()
      }
    }
    
    cryptoListViewModel.getCryptoList()
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testCryptoListAPIResultCount() {
    let expectation = self.expectation(description: "Invalid number of entries returns by crypto list API.")
    
    cryptoListViewModel.error.bind { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
    
    cryptoListViewModel.cryptoCoins.bind { (cryptoList) in
      if cryptoList?.count == 5 {
        expectation.fulfill()
      }
    }
    
    cryptoListViewModel.getCryptoList()
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testCryptoAPIObject() {
    let expectation = self.expectation(description: "Invalid number of entries returns by crypto list API.")
    
    cryptoListViewModel.error.bind { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
    
    cryptoListViewModel.cryptoCoins.bind { (cryptoList) in
      if let crypto = cryptoList?[0] {
        XCTAssert(crypto.name == "Bitcoin", "Crypto name is incorrect.")
        XCTAssert(crypto.symbol == "BTC", "Crypto symbol is incorrect.")
        XCTAssert(crypto.type == .coin, "Crypto type is incorrect")
        XCTAssert(crypto.isNew == false, "Crypto is new.")
        XCTAssert(crypto.isActive == true, "Crypto is not active.")
        expectation.fulfill()
      }
    }
    
    cryptoListViewModel.getCryptoList()
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testUpdateCryptoListWithActiveCoins() {
    let expectation = self.expectation(description: "Invalid number of entries returns by crypto list API.")
    
    cryptoListViewModel.error.bind { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
    
    cryptoListViewModel.filteredCoins.bind { (cryptoList) in
      if cryptoList?.count == 4 {
        expectation.fulfill()
      }
    }
    
    cryptoListViewModel.cryptoCoins.value = getCryptoListFromLocal()
    cryptoListViewModel.updateFilteredList(filters: Set(arrayLiteral: .activeCoins))
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testUpdateCryptoListWithInactiveCoins() {
    let expectation = self.expectation(description: "Invalid number of entries returns by crypto list API.")
    
    cryptoListViewModel.error.bind { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
    
    cryptoListViewModel.filteredCoins.bind { (cryptoList) in
      if cryptoList?.count == 1 {
        expectation.fulfill()
      }
    }
    
    cryptoListViewModel.cryptoCoins.value = getCryptoListFromLocal()
    cryptoListViewModel.updateFilteredList(filters: Set(arrayLiteral: .inactiveCoins))
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testUpdateCryptoListWithOnlyCoins() {
    let expectation = self.expectation(description: "Invalid number of entries returns by crypto list API.")
    
    cryptoListViewModel.error.bind { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
    
    cryptoListViewModel.filteredCoins.bind { (cryptoList) in
      if cryptoList?.count == 4 {
        expectation.fulfill()
      }
    }
    
    cryptoListViewModel.cryptoCoins.value = getCryptoListFromLocal()
    cryptoListViewModel.updateFilteredList(filters: Set(arrayLiteral: .onlyCoins))
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testUpdateCryptoListWithOnlyTokens() {
    let expectation = self.expectation(description: "Invalid number of entries returns by crypto list API.")
    
    cryptoListViewModel.error.bind { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
    
    cryptoListViewModel.filteredCoins.bind { (cryptoList) in
      if cryptoList?.count == 1 {
        expectation.fulfill()
      }
    }
    
    cryptoListViewModel.cryptoCoins.value = getCryptoListFromLocal()
    cryptoListViewModel.updateFilteredList(filters: Set(arrayLiteral: .onlyToken))
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testUpdateCryptoListWithNewCoins() {
    let expectation = self.expectation(description: "Invalid number of entries returns by crypto list API.")
    
    cryptoListViewModel.error.bind { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
    
    cryptoListViewModel.filteredCoins.bind { (cryptoList) in
      if cryptoList?.count == 1 {
        expectation.fulfill()
      }
    }
    
    cryptoListViewModel.cryptoCoins.value = getCryptoListFromLocal()
    cryptoListViewModel.updateFilteredList(filters: Set(arrayLiteral: .newCoins))
    self.waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  private func getCryptoListFromLocal() -> [Crypto]? {
    let path = Bundle.main.path(forResource: "cryptoList", ofType: "json")
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
      let data = try String(contentsOfFile: path!).data(using: .utf8)
      let result =  try decoder.decode([Crypto].self, from: data!)
      return result
    } catch(let error) {
      print("Encountered error: \(error.localizedDescription)")
      return nil
    }
  }
  
}
