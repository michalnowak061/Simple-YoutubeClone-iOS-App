//
//  PlaylistsVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 06/10/2020.
//

import UIKit

class PlaylistsVC: UIViewController {
    struct ItemToDisplay {
        let image: UIImage
        let title: String
    }
    
    var model: Model = Model()
    var playlists: Playlists? = nil
    var thumbnails: [String : UIImage] = [:]
    var dataToDisplay: [ItemToDisplay] = []
    var loadedPages: [String] = []
    let mainQueue = DispatchQueue.main
    let dataQueue = DispatchQueue.init(label: "dataQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    private func viewSetup() {
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
            self.model.getPlaylists()
        }
    
        collectionViewSetup()
        dataSetup()
    }

    private func prepareDataToDisplay() {
        if let playlists = self.model.playlists {
            for item in playlists.items {
                let id = item.id
                let image = thumbnails[id]
                let title = item.snippet.title
                let itemToDisplay = ItemToDisplay(image: image!, title: title)
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
            if let playlists = self.model.playlists {
                if let nextPageToken = playlists.nextPageToken {
                    guard !self.loadedPages.contains(nextPageToken) else {
                        return
                    }
                    self.model.getPlaylists(pageToken: nextPageToken)
                    self.loadedPages.append(nextPageToken)
                }
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
}

extension PlaylistsVC: ModelDelegate {
    func getPlaylistsCompleted() {
        self.model.getPlaylistsThumbnails()
    }
    func getPlaylistsThumbnailsCompleted() {
        self.thumbnails = self.model.playlistsThumbnails
        self.updateView()
    }
}

extension PlaylistsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistsCVC().id, for: indexPath) as! PlaylistsCVC
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
            
        let item = dataToDisplay[indexPath.row]
        cell.image.image = item.image
        cell.titleLabel.text = item.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let offset = 5
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - offset {
            self.downloadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.selectedVideoId = self.search?.items[indexPath.row].id.videoID ?? ""
        //performSegue(withIdentifier: "presentPlayerVC", sender: self)
    }
}
