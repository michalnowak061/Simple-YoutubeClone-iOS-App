//
//  Model.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 26/09/2020.
//

import Foundation
import Alamofire

struct Constants {
    static var API_KEY = "AIzaSyB9QME2XB3dNG5tTN9tlE9jY8rcUiQ8f0Y"
    static var PLAYLIST_ID = "UULm7DMKc2OAPTihoGQwCWmw"
    static var API_URL = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
}

class Model {
    var playListItems: PlayListItems?
    
    func getPlayListItems() {
        AF.request(Constants.API_URL, method: .get).response { response in
            if response.error == nil {
                if response.data != nil {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        self.playListItems = try decoder.decode(PlayListItems.self, from: response.data!)
                        print(self.playListItems!)
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
