//
//  Model.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 26/09/2020.
//

import Foundation
import Alamofire

protocol ModelDelegate {
    func searchedItemsFetched(_ searchedItems: SearchedItems)
    func playListItemsFetched(_ playListItems: PlayListItems)
}

class Model {
    let API_URL = "https://www.googleapis.com/youtube/v3/"
    let API_KEY = "AIzaSyC8renxi8A86PsIqgh8jtdCBA9EsdgFckU"
    
    var delegate: ModelDelegate?
    var searchedItems: SearchedItems?
    var playListItems: PlayListItems?
    
    func getSearchList(q: String, maxResults: Int) {
        let url = "\(API_URL)search?part=snippet&maxResults=\(maxResults)&q=\(q)&type=video&key=\(API_KEY)"
        //let url = "\(API_URL)search?part=snippet&maxResults=\(maxResults)&q=\(q)&key=\(API_KEY)"
        
        AF.request(url, method: .get).response { response in
            if response.error == nil {
                if response.data != nil {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        self.searchedItems = try decoder.decode(SearchedItems.self, from: response.data!)
                        self.delegate?.searchedItemsFetched(self.searchedItems!)
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
