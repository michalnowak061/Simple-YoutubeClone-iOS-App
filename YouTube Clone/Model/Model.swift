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
    let API_KEY = "AIzaSyC8renxi8A86PsIqgh8jtdCBA9EsdgFckU"
    
    var delegate: ModelDelegate?
    var thumbnails: [String : UIImage] = [:]
    var search: Search? = nil
    var playListItems: PlayListItems? = nil
    
    func getThumbnails() {
        self.thumbnails = [:]

        for item in search!.items {
            let url = item.snippet.thumbnails.medium.url
            
            AF.request(url).response { [self] response in
                guard response.data != nil else {
                    return
                }
                if let image = UIImage(data: response.data!, scale: 1) {
                    thumbnails[url] = image
                    if thumbnails.count == search!.items.count {
                        self.delegate?.getThumbnailsCompleted(thumbnails)
                    }
                }
            }
        }
    }
    
    func getSearch(q: String = "", maxResults: String = "", type: String = "", pageToken: String = "") {
        self.search = nil

        var url = "https://www.googleapis.com/youtube/v3/search?part=snippet"
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
                        self.delegate?.getSearchCompleted(self.search!)
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
    
    func getPlayListItems(withId playlistId: String) {
        let url = "\(API_URL)playlistItems?part=snippet&playlistId=\(playlistId)&key=\(API_KEY)"
        
        AF.request(url, method: .get).response { response in
            if response.error == nil {
                if response.data != nil {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        self.playListItems = try decoder.decode(PlayListItems.self, from: response.data!)
                        self.delegate?.playListItemsFetched(self.playListItems!)
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
}
