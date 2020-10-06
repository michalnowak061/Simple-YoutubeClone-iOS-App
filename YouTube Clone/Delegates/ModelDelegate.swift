//
//  ModelDelegate.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 04/10/2020.
//

import UIKit

@objc protocol ModelDelegate {
    @objc optional func getSearchCompleted()
    @objc optional func getSearchThumbnailsCompleted()
    @objc optional func playListItemsFetched()
    @objc optional func getPlaylistsCompleted()
    @objc optional func getPlaylistsThumbnailsCompleted()
}
