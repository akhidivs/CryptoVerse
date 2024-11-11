//
//  NoDataView.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 11/11/24.
//

import UIKit

class NoDataView: UIView {
  
  weak var delegate: RemoveFilters?
    
  private let label: UILabel = {
    let label = UILabel()
    label.text = "No coins or tokens to display"
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let button: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Remove all filters", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    addSubview(label)
    addSubview(button)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
    ])
    
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  @objc private func buttonTapped() {
    delegate?.removeAllFilters()
  }
}

