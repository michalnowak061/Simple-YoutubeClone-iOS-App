//
//  Model.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 26/09/2020.
//

import UIKit
import Alamofire

protocol ModelDelegate {
    func getSearchCompleted(_ search: Search)
    func getThumbnailsCompleted(_ thumbnails: [UIImage])
    func playListItemsFetched(_ playListItems: PlayListItems)
}

class Model {
    let API_URL = "https://www.googleapis.com/youtube/v3/"
    let API_KEY = "AIzaSyC8renxi8A86PsIqgh8jtdCBA9EsdgFckU"
    
    var delegate: ModelDelegate?
    var thumbnails: [UIImage] = []
    var search: Search? = nil
    var playListItems: PlayListItems? = nil
    
    func getThumbnails(urls: [String]) {
        for url in urls {
            AF.request(url).response { [self] response in
                guard response.data != nil else {
                    return
                }
                if let image = UIImage(data: response.data!, scale: 1) {
                    thumbnails.append(image)
                    if thumbnails.count == urls.count {
                        self.delegate?.getThumbnailsCompleted(thumbnails)
                    }
                }
            }
        }
    }
    
    func getSearch(q: String, maxResults: Int, type: String = "channel+playlist+video") {
        let url = "\(API_URL)search?part=snippet&maxResults=\(maxResults)&q=\(q)&type=\(type)&key=\(API_KEY)"
        
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
        /*
        if let url = Bundle.main.url(forResource: "jsonTest", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                //let jsonData = try decoder.decode(ResponseData.self, from: data)
                self.search = try decoder.decode(Search.self, from: data)
                self.delegate?.getSearchCompleted(self.search!)
                //return jsonData.person
            } catch {
                print("error:\(error)")
            }
        }*/
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
