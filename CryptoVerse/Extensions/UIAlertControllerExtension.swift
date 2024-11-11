//
//  UIAlertControllerExtension.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 11/11/24.
//

import Foundation
import UIKit

extension UIAlertController {
  static func show(_ message: String, from viewController: UIViewController) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
  }
}
