//
//  CryptoListTableViewCell.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 10/11/24.
//

import UIKit

class CryptoListTableViewCell: UITableViewCell {
  
  static let identifier = "CryptoListTableViewCell"
  
  private var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .gray
    label.font = .systemFont(ofSize: 18)
    return label
  }()
  
  private var symbolLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .gray
    label.font = .systemFont(ofSize: 16, weight: .bold)
    return label
  }()
  
  private var typeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.zPosition = 1
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private var newCryptoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.zPosition = -1
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupCell() {
    
    contentView.addSubview(nameLabel)
    contentView.addSubview(symbolLabel)
    contentView.addSubview(typeImageView)
    contentView.addSubview(newCryptoImageView)
    
    NSLayoutConstraint.activate([
      
      newCryptoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      newCryptoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      newCryptoImageView.widthAnchor.constraint(equalToConstant: 28),
      newCryptoImageView.heightAnchor.constraint(equalToConstant: 28),
      
      typeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      typeImageView.widthAnchor.constraint(equalToConstant: 36),
      typeImageView.heightAnchor.constraint(equalToConstant: 36),
      
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      nameLabel.trailingAnchor.constraint(equalTo: typeImageView.leadingAnchor, constant: -16),
      
      symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      symbolLabel.trailingAnchor.constraint(equalTo: typeImageView.leadingAnchor, constant: -16)
      
    ])
  }
  
  func render(_ item: Crypto) {
    selectionStyle = .none
    nameLabel.text = item.name
    symbolLabel.text = item.symbol
    if item.isActive {
      typeImageView.image = UIImage(named: item.type.rawValue)
    } else {
      typeImageView.image = UIImage(named: "inactive")
    }
    
    newCryptoImageView.image = UIImage(named: "new")
    newCryptoImageView.isHidden = !item.isNew
  }
}
