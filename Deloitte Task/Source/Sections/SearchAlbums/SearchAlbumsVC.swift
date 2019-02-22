//
//  SearchAlbumsVC.swift
//  Deloitte Task
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import UIKit

class SearchAlbumsVC: UIViewController {
    fileprivate static let segueToDetailes = "showAlbumDetails"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var albums = [AlbumModel]()
    private var selectedIndex: Int = -1
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController.searchBar.becomeFirstResponder()
    }

    //MARk: - private
    private func setupSearchController() {
        self.searchController.delegate = self
        
        self.searchController.searchBar.barStyle = .black
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search..."
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = self.collectionView.frame.width
        let size: CGFloat = 60
        let cellsInRow: Int = Int(width / size)
        let margin = (width - size * CGFloat(cellsInRow)) / CGFloat(cellsInRow)
        let halfMargin = margin / 2
        
        flow.sectionInset = UIEdgeInsets(top: 2, left: halfMargin, bottom: 2, right: halfMargin)
        flow.itemSize = CGSize(width: size, height: size)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = margin
    }

    fileprivate func fetchAlbums(for searchString: String) {
        NetworkService.getAlbums(searchString: searchString) { [weak self] result in
            switch result {
            case .success(let albums):
                self?.albums = albums
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.updateDescription()
                }
            case .failure(let error):
                print("NetworkService.getAlbums.error: \(error)")
            }
        }
    }
    
    fileprivate func updateDescription() {
        self.descriptionLabel.text = ""
        if self.albums.count > 0 {
            var visibleItems = self.collectionView.indexPathsForVisibleItems
            visibleItems.sort(by: {return $0.row < $1.row})
            let index = visibleItems.count > 0 ? visibleItems[0].row : 0
            
            let data = self.albums[index]
            self.descriptionLabel.text = "\(data.collectionName) \(data.artistName). \(data.copyright), \(data.country)"
        }
        self.descriptionLabel.sizeToFit()
    }
    
    //MARK: - public
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SearchAlbumsVC.segueToDetailes {
            if let detailedViewController = segue.destination as? AlbumDetailsVC {
                detailedViewController.model = self.albums[self.selectedIndex]
            }
        }
    }
    
}

extension SearchAlbumsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdentifier,
                                                             for: indexPath) as? AlbumCell {
            cell.render(props: self.albums[indexPath.row])
            return cell
        }
            
        assert(false, "Unhandled collectionView cell type.")
        return UICollectionViewCell()
    }
    
}

extension SearchAlbumsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: SearchAlbumsVC.segueToDetailes, sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateDescription()
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension SearchAlbumsVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        self.fetchAlbums(for: searchText ?? "")
    }
}
