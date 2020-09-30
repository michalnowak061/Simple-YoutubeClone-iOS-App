//
//  SearchResultVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 28/09/2020.
//

import UIKit

class SearchResultVC: UIViewController {
    var barTitle: String = ""
    var model: Model = Model()
    var search: Search? = nil
    var thumbnails: [UIImage] = []
    let mainQueue = DispatchQueue.main
    let dataQueue = DispatchQueue.init(label: "dataQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    private func viewSetup() {
        func navigationBarSetup() {
            navigationBar.topItem?.title = barTitle
        }
        func collectionViewSetup() {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.15)
            
            self.collectionView.collectionViewLayout = layout
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
        func dataSetup() {
            self.search = self.model.search
            self.model.delegate = self
            self.downloadThumbnails()
        }
        
        dataSetup()
        navigationBarSetup()
        collectionViewSetup()
    }
    
    private func updateView() {
        mainQueue.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadThumbnails() {
        guard self.search != nil else {
            return
        }
        dataQueue.async {
            var urls: [String] = []
            for item in self.search!.items {
                let url = item.snippet.thumbnails.medium.url
                urls.append(url)
            }
            self.model.getThumbnails(urls: urls)
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchResultVC: ModelDelegate {
    func getThumbnailsCompleted(_ thumbnails: [UIImage]) {
        self.thumbnails = self.model.thumbnails
        self.updateView()
    }
    func getSearchCompleted(_ search: Search) {}
    func playListItemsFetched(_ playListItems: PlayListItems) {}
}

extension SearchResultVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCVC().id, for: indexPath) as! SearchResultCVC
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
            
        let item = search?.items[indexPath.row]
        if thumbnails.count != 0 {
            cell.thumbnailImageView.image = self.thumbnails[indexPath.row]
        }
        cell.titleLabel.text = item?.snippet.title
        cell.channelNameLabel.text = item?.snippet.channelTitle
        
        return cell
    }
}
