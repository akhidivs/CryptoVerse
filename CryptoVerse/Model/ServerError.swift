//
//  ServerError.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

struct ServerError: Decodable {
    let status: String?
    let error: String?
}
