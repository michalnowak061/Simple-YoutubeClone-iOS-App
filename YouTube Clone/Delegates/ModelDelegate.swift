//
//  ModelDelegate.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 04/10/2020.
//

import UIKit

protocol ModelDelegate {
    func getSearchCompleted(_ search: Search)
    func getThumbnailsCompleted(_ thumbnails: [String : UIImage])
    func playListItemsFetched(_ playListItems: PlayListItems)
}
