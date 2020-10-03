//
//  MainVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 26/09/2020.
//

import UIKit

class PlayListItemsVC: UIViewController {
    var model = Model()
    var playListItems: PlayListItems?
    let mainQueue = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    private func viewSetup() {
        func collectionViewSetup() {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.25)
            
            self.collectionView.collectionViewLayout = layout
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
        
        collectionViewSetup()
        self.model.delegate = self
        self.model.getPlayListItems(withId: "UULm7DMKc2OAPTihoGQwCWmw")
    }
    
    private func updateView() {
        mainQueue.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
}

extension PlayListItemsVC: ModelDelegate {
    func getThumbnailsCompleted(_ thumbnails: [String : UIImage]) {}
    func getSearchCompleted(_ searchedItems: Search) {}
    func playListItemsFetched(_ playListItems: PlayListItems) {
        self.playListItems = playListItems
        self.updateView()
    }
}

extension PlayListItemsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playListItems?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayListItemCVC().id, for: indexPath) as! PlayListItemCVC
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundColor = .gray
        
        let item = playListItems?.items[indexPath.row]
        cell.titleLabel.text = item?.snippet.title
        
        return cell
    }
}
