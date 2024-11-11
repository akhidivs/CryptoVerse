//
//  CryptoListViewModel.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

class CryptoListViewModel {
  
  private var httpClient: HTTPClient!
  
  let title = NSLocalizedString("COIN", comment: "")
  
  var cryptoCoins: Bindable<[Crypto]?> = Bindable(nil)
  var filteredCoins: Bindable<[Crypto]?> = Bindable(nil)
  var error: Bindable<CryptoError?> = Bindable(nil)
  
  init(client: HTTPClient? = nil) {
    self.httpClient = client ?? HTTPClient.shared
  }
  
  func getCryptoList() {
    httpClient.dataTask(CryptoAPI.getCryptoList) { [weak self] (result) in
      guard let self = self else {
        return
      }
      
      switch result {
      case .success(let data):
        guard let data = data else {
          return
        }
        
        do {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let cryptoCoins = try decoder.decode([Crypto].self, from: data)
          self.cryptoCoins.value = cryptoCoins
          self.filteredCoins.value = cryptoCoins
        } catch {
          print("Unable to decode crypto list")
        }
        
      case .failure(let error):
        self.error.value = error
        print("Error in fetching crypto list")
      }
    }
  }
  
  func updateFilteredList(filters: Set<CryptoFilters>) {
    
    var newList: [Crypto] = cryptoCoins.value ?? []
    
    filters.forEach { filterApplied in
      switch filterApplied {
        case .activeCoins:
        newList = newList.filter { $0.isActive == true }
      case .inactiveCoins:
        newList = newList.filter { $0.isActive == false }
      case .onlyToken:
        newList = newList.filter { $0.type == .token }
      case .onlyCoins:
        newList = newList.filter { $0.type == .coin }
      case .newCoins:
        newList = newList.filter { $0.isNew == true }
      }
    }
    
    filteredCoins.value = newList

  }
  
}
