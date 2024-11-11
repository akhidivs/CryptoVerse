//
//  ChipCell.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 10/11/24.
//

import UIKit

class ChipCell: UICollectionViewCell {
  
  static let identifier = "ChipCell"
  
  private var imageWidthConstraint: NSLayoutConstraint!
  
  private let checkmarkImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "checkmark")
    imageView.isHidden = true
    return imageView
  }()
    
  private let label: UILabel = {
    let label = UILabel()
    label.textColor = .darkText
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = Constants.Colors.chipBgColor
    contentView.layer.cornerRadius = 16
    contentView.layer.masksToBounds = true
    contentView.addSubview(label)
    contentView.addSubview(checkmarkImageView)
    
    imageWidthConstraint = checkmarkImageView.widthAnchor.constraint(equalToConstant: 0)
    
    NSLayoutConstraint.activate([
      checkmarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
      imageWidthConstraint,

      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      label.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 0),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with text: String, filters: Set<CryptoFilters>) {
    label.text = text
    guard let filter = CryptoFilters(rawValue: text)  else { return }
    let isFilterActive = filters.contains(filter)
    checkmarkImageView.isHidden = !isFilterActive
    contentView.backgroundColor = isFilterActive ? Constants.Colors.chipBgSelected : Constants.Colors.chipBgColor
    imageWidthConstraint.constant = isFilterActive ? 24 : 0
  }
  
  func getItem() -> String {
    return label.text ?? ""
  }

}
