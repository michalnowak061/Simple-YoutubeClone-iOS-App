//
//  SearchResultVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 28/09/2020.
//

import UIKit

class SearchResultVC: UIViewController {
    struct ItemToDisplay {
        let image: UIImage
        let title: String
        let channelName: String
    }
    
    var barTitle: String = ""
    var model: Model = Model()
    var search: Search? = nil
    var thumbnails: [UIImage] = []
    var dataToDisplay: [ItemToDisplay] = []
    let mainQueue = DispatchQueue.main
    let dataQueue = DispatchQueue.init(label: "dataQueue")
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
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
            self.model.delegate = self
            self.model.search = self.search
            self.downloadThumbnails()
        }
        
        navigationBarSetup()
        collectionViewSetup()
        dataSetup()
    }
    
    private func prepareDataToDisplay() {
        if let search = self.model.search {
            var iterator: Int = 0
            for item in search.items {
                let image = thumbnails[iterator]
                let title = item.snippet.title
                let channelName = item.snippet.channelTitle
                let itemToDisplay = ItemToDisplay(image: image, title: title, channelName: channelName)
                self.dataToDisplay.append(itemToDisplay)
                iterator += 1
            }
        }
    }
    
    private func updateView() {
        mainQueue.async {
            self.prepareDataToDisplay()
            self.collectionView.reloadData()
        }
    }
    
    private func downloadThumbnails() {
        dataQueue.async {
            if let search = self.model.search {
                var urls: [String] = []
                for item in search.items {
                    let url = item.snippet.thumbnails.medium.url
                    urls.append(url)
                }
                self.model.getThumbnails(urls: urls)
            }
        }
    }
    
    private func downloadNextPage() {
        dataQueue.async {
            if let search = self.model.search {
                let nextPageToken = search.nextPageToken
                let keywords = self.barTitle
                self.model.getSearch(q: keywords, maxResults: "11", nextPageToken: nextPageToken)
            }
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        fromleftToRightAnimation()
    }
    
    @IBAction func swipeBackGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        let swipeMaxDistance = self.view.frame.size.width
        let dismissActivationDistance = self.view.frame.size.width * 0.5
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.x - initialTouchPoint.x > 0 && touchPoint.x - initialTouchPoint.x < swipeMaxDistance {
                self.view.frame = CGRect(x: touchPoint.x - initialTouchPoint.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.x - initialTouchPoint.x > dismissActivationDistance {
                fromleftToRightAnimation()
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}

extension SearchResultVC: ModelDelegate {
    func getThumbnailsCompleted(_ thumbnails: [UIImage]) {
        self.thumbnails = self.model.thumbnails
        self.updateView()
    }
    func getSearchCompleted(_ search: Search) {
        self.downloadThumbnails()
    }
    func playListItemsFetched(_ playListItems: PlayListItems) {}
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
        print("CLICKED \(indexPath.row)")
    }
}
