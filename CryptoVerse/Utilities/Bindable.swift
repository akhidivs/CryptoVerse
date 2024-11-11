//
//  Bindable.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import Foundation

class Bindable<T> {
  
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else {
          return
        }
        
        self.listener?(self.value)
      }
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
