//
//  CryptoModel.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

enum CryptoFilters: String, CaseIterable {
  case activeCoins = "Active Coins"
  case inactiveCoins = "Inactive Coins"
  case onlyToken = "Only Tokens"
  case onlyCoins = "Only Coins"
  case newCoins = "New Coins"
}

enum CryptoType: String, Codable {
  case coin = "coin"
  case token = "token"
}

struct Crypto: Codable {
  var name: String
  var symbol: String
  var isNew: Bool
  var isActive: Bool
  var type: CryptoType
}
