//
//  SearchedItems.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 27/09/2020.
//

import Foundation

// MARK: - SearchedItems
struct Search: Codable {
    let kind, etag, nextPageToken, regionCode: String
    let pageInfo: SearchPageInfo
    let items: [SearchItem]
}

// MARK: - Item
struct SearchItem: Codable {
    let kind, etag: String
    let id: ID
    let snippet: SearchSnippet
}

// MARK: - ID
struct ID: Codable {
    let kind: String
    let channelID, videoID: String?

    enum CodingKeys: String, CodingKey {
        case kind
        case channelID = "channelId"
        case videoID = "videoId"
    }
}

// MARK: - Snippet
struct SearchSnippet: Codable {
    let publishedAt: Date
    let channelID, title, snippetDescription: String
    let thumbnails: SearchThumbnails
    let channelTitle, liveBroadcastContent: String
    let publishTime: Date

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle, liveBroadcastContent, publishTime
    }
}

// MARK: - Thumbnails
struct SearchThumbnails: Codable {
    let thumbnailsDefault, medium, high: SearchDefault

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high
    }
}

// MARK: - SearchedItemsDefault
struct SearchDefault: Codable {
    let url: String
    let width, height: Int?
}

// MARK: - PageInfo
struct SearchPageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
