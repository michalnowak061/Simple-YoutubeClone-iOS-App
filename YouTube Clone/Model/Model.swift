//
//  Model.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 26/09/2020.
//

import UIKit
import Alamofire

class Model {
    let API_URL = "https://www.googleapis.com/youtube/v3/"
    var delegate: ModelDelegate?
    var search: Search? = nil
    var searchThumbnails: [String : UIImage] = [:]
    var playListItems: PlayListItems? = nil
    var playlists: Playlists? = nil
    var playlistsThumbnails: [String : UIImage] = [:]
    
    // MARK: - Search methods
    func getSearchThumbnails() {
        self.searchThumbnails = [:]

        for item in search!.items {
            var url = item.snippet.thumbnails.medium.url
            if !url.contains("https") {
                url = url.replacingOccurrences(of: "http", with: "https")
            }
            AF.request(url).response { [self] response in
                guard response.data != nil else {
                    return
                }
                if let image = UIImage(data: response.data!, scale: 1) {
                    let id = item.id.videoID ?? ""
                    searchThumbnails[id] = image
                    if searchThumbnails.count == search!.items.count {
                        self.delegate?.getSearchThumbnailsCompleted!()
                    }
                }
            }
        }
    }
    func getSearch(q: String = "", maxResults: String = "", type: String = "", pageToken: String = "") {
        self.search = nil

        var url = "\(API_URL)search?part=snippet"
        url += "&q=\(q)"
        url += "&maxResults=\(maxResults)"
        url += "&type=\(type)"
        url += "&pageToken=\(pageToken)"
        url += "&access_token=\(googleUser.accessToken)"
        
        AF.request(url, method: .get).response { response in
            if response.error == nil {
                if response.data != nil {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        self.search = try decoder.decode(Search.self, from: response.data!)
                        self.delegate?.getSearchCompleted!()
                    } catch let error {
                        print("getSearchList: " + "\(error)")
                    }
                }
            }
            else {
                print(response.error!)
            }
        }
    }
    
    // MARK: - PlayListitems methods
    func getPlayListItems(withId playlistId: String) {
        self.playListItems = nil
        
        var url = "\(API_URL)playlistItems?part=snippet"
        url += "&playlistId=\(playlistId)"
        url += "&access_token=\(googleUser.accessToken)"
        
        AF.request(url, method: .get).response { response in
            if response.error == nil {
                if response.data != nil {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        self.playListItems = try decoder.decode(PlayListItems.self, from: response.data!)
                        self.delegate?.playListItemsFetched!()
                    } catch let error {
                        print("getPlayListItems: " + "\(error)")
                    }
                }
            }
            else {
                print(response.error!)
            }
        }
    }
    func postPlayListItems() {}
    func putPlayListItems() {}
    func deletePlayListItems() {}
    
    // MARK: - Playlists methods
    func getPlaylistsThumbnails() {
        self.playlistsThumbnails = [:]

        for item in playlists!.items {
            var url = item.snippet.thumbnails.thumbnailsDefault?.url ?? ""
            if !url.contains("https") {
                url = url.replacingOccurrences(of: "http", with: "https")
            }
            AF.request(url).response { [self] response in
                guard response.data != nil else {
                    return
                }
                if let image = UIImage(data: response.data!, scale: 1) {
                    let id = item.id
                    playlistsThumbnails[id] = image
                    if playlistsThumbnails.count == playlists!.items.count {
                        self.delegate?.getPlaylistsThumbnailsCompleted!()
                    }
                }
            }
        }
    }
    func getPlaylists(maxResults: String = "10", pageToken: String = "") {
        self.playlists = nil
        
        var url = "\(API_URL)playlists?part=snippet"
        url += "&maxResults=\(maxResults)"
        url += "&mine=true"
        url += "&pageToken=\(pageToken)"
        url += "&access_token=\(googleUser.accessToken)"
        
        AF.request(url, method: .get).response { response in
            if response.error == nil {
                if response.data != nil {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        self.playlists = try decoder.decode(Playlists.self, from: response.data!)
                        self.delegate?.getPlaylistsCompleted!()
                    } catch let error {
                        print("getPlaylist: " + "\(error)")
                    }
                }
            }
            else {
                print(response.error!)
            }
        }
    }
    func postPlaylists() {}
    func updatePlaylists() {}
    func deletePlaylists() {}
}
