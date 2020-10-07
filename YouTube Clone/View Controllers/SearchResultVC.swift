//
//  SearchResultVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 28/09/2020.
//

import UIKit

class SearchResultVC: UIViewController {
    struct ItemToDisplay {
        let id: String
        let image: UIImage
        let title: String
        let channelName: String
    }
    
    var barTitle: String = ""
    var model: Model = Model()
    var search: Search? = nil
    var thumbnails: [String : UIImage] = [:]
    var dataToDisplay: [ItemToDisplay] = []
    var selectedVideoId: String = ""
    let mainQueue = DispatchQueue.main
    let dataQueue = DispatchQueue.init(label: "dataQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PlayerVC {
            vc.videoId = self.selectedVideoId
        }
    }
    
    private func viewSetup() {
        func navigationBarSetup() {
            self.navigationItem.title = barTitle
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
            self.model.delegate = self
            self.model.search = self.search
            self.model.getSearchThumbnails()
        }
        
        navigationBarSetup()
        collectionViewSetup()
        dataSetup()
    }
    
    private func prepareDataToDisplay() {
        if let search = self.model.search {
            for item in search.items {
                let id = item.id.videoID ?? ""
                let image = thumbnails[id]
                let title = item.snippet.title
                let channelName = item.snippet.channelTitle
                let itemToDisplay = ItemToDisplay(id: id, image: image!, title: title, channelName: channelName)
                self.dataToDisplay.append(itemToDisplay)
            }
        }
    }
    
    private func updateView() {
        mainQueue.async {
            self.prepareDataToDisplay()
            self.collectionView.reloadData()
        }
    }
    
    private func downloadNextPage() {
        dataQueue.async {
            if let search = self.model.search {
                let nextPageToken = search.nextPageToken
                var keywords = self.barTitle
                keywords = keywords.convertedToSlug() ?? ""
                self.model.getSearch(q: keywords, maxResults: "11", type: "video", pageToken: nextPageToken)
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
}

extension SearchResultVC: ModelDelegate {
    func getSearchThumbnailsCompleted() {
        self.thumbnails = self.model.searchThumbnails
        self.updateView()
    }
    func getSearchCompleted() {
        self.model.getSearchThumbnails()
    }
}

extension SearchResultVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCVC().id, for: indexPath) as! SearchResultCVC
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
            
        let item = dataToDisplay[indexPath.row]
        cell.thumbnailImageView.image = item.image
        cell.titleLabel.text = item.title
        cell.channelNameLabel.text = item.channelName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let offset = 5
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - offset {
            self.downloadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedVideoId = self.dataToDisplay[indexPath.row].id
        performSegue(withIdentifier: "presentPlayerVC", sender: self)
    }
}
