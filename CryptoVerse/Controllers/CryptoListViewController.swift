//
//  CryptoListViewController.swift
//  CryptoVerse
//
//  Created by Akhilesh Mishra on 09/11/24.
//

import UIKit

protocol RemoveFilters: AnyObject {
  func removeAllFilters()
}

class CryptoListViewController: UIViewController {
  
  // MARK: Private properties
  private var filterHeightConstraint: NSLayoutConstraint!
  private var filtersApplied = Set<CryptoFilters>()
  
  private var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.isHidden = true
    return tableView
  }()
  
  private var filterView: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    return view
  }()
  
  private var noDataView: NoDataView = {
    let view = NoDataView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
    return view
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
        return CryptoListViewController.createChipsLayout()
    }
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  private var loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = Constants.Colors.navBarColor
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  private let viewModel = CryptoListViewModel()
  
  
  // MARK: View Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setupViews()
    setupBindingAndGetCryptoList()
  }
  
  // MARK: Private methods
  private func setupViews() {
    setupNavBarItems()
    noDataView.delegate = self
    view.addSubview(tableView)
    view.addSubview(filterView)
    view.addSubview(noDataView)
    view.addSubview(loadingIndicator)
    
    filterHeightConstraint = filterView.heightAnchor.constraint(equalToConstant: 120)
    
    NSLayoutConstraint.activate([
      
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      noDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noDataView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noDataView.widthAnchor.constraint(equalTo: view.widthAnchor),
      noDataView.heightAnchor.constraint(equalToConstant: 120),
      
      filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      filterHeightConstraint,
      
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: filterView.topAnchor)
    ])
    
    loadingIndicator.startAnimating()
    tableView.register(CryptoListTableViewCell.self,
                       forCellReuseIdentifier: CryptoListTableViewCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.dataSource = self
    setupFilterView()
  }
  
  private func setupNavBarItems() {
    let label = UILabel()
    label.textColor = UIColor.white
    label.text = viewModel.title
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    
    let rightBarButtonItem = UIBarButtonItem(systemItem: .search)
    rightBarButtonItem.tintColor = .white
    self.navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  private func setupFilterView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(ChipCell.self, forCellWithReuseIdentifier: ChipCell.identifier)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = Constants.Colors.filterBgColor
    
    filterView.addSubview(collectionView)
          
    // Set constraints for collection view within the footer view
    NSLayoutConstraint.activate([
        collectionView.leadingAnchor.constraint(equalTo: filterView.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: filterView.trailingAnchor),
        collectionView.topAnchor.constraint(equalTo: filterView.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: filterView.bottomAnchor)
    ])
    
  }
  
  private func setupBindingAndGetCryptoList() {
    
    viewModel.error.bind { [unowned self] (error) in
      if let error = error {
        // Show error alert
        self.loadingIndicator.stopAnimating()
        UIAlertController.show(error.localizedDescription, from: self)
      }
    }
    
    viewModel.filteredCoins.bind { [unowned self] (filteredList) in
      if filteredList != nil {
        if filteredList?.count == 0 {
          self.tableView.isHidden = true
          self.noDataView.isHidden = false
          self.loadingIndicator.stopAnimating()
        } else {
          self.tableView.isHidden = false
          self.noDataView.isHidden = true
          self.tableView.reloadData()
          self.loadingIndicator.stopAnimating()
        }
      }
    }
    
    viewModel.getCryptoList()
  }
  
  // MARK: - Layout
  private static func createChipsLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .estimated(90),
        heightDimension: .absolute(32)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(40)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = .fixed(8)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    
    return section
  }
  
  private func updateCollectionViewHeight() {
    let updatedHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
    filterHeightConstraint.constant = updatedHeight
  }

}


// MARK: UITableViewDataSource
extension CryptoListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.filteredCoins.value?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: CryptoListTableViewCell.identifier,
      for: indexPath) as? CryptoListTableViewCell else {
      return UITableViewCell()
    }
    
    guard let item = viewModel.filteredCoins.value?[indexPath.row] else {
      return UITableViewCell()
    }
    
    cell.render(item)
    return cell
  }
  
}

// MARK: - UICollectionViewDataSource
extension CryptoListViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return CryptoFilters.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipCell.identifier, for: indexPath) as? ChipCell else {
        return UICollectionViewCell()
    }
    cell.configure(with: CryptoFilters.allCases[indexPath.item].rawValue, filters: filtersApplied)
    return cell
  }
  
}

// MARK: UICollectionViewDelegate
extension CryptoListViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? ChipCell else { return }
    guard let item = CryptoFilters(rawValue: cell.getItem()) else { return }
    
    if filtersApplied.contains(item) {
      filtersApplied.remove(item)
    } else {
      filtersApplied.insert(item)
    }
        
    viewModel.updateFilteredList(filters: filtersApplied)
    collectionView.reloadItems(at: [indexPath])
    updateCollectionViewHeight()
  }
  
}

// MARK: RemoveFilters Protocol Confirmation
extension CryptoListViewController: RemoveFilters {
  
  func removeAllFilters() {
    filtersApplied.removeAll()
    viewModel.updateFilteredList(filters: filtersApplied)
    collectionView.reloadData()
    updateCollectionViewHeight()
  }
  
}
