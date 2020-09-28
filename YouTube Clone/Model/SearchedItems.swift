//
//  SearchedItems.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 27/09/2020.
//

import Foundation

// MARK: - SearchedItems
struct SearchedItems: Codable {
    let kind, etag, nextPageToken, regionCode: String
    let pageInfo: SearchedItemsPageInfo
    let items: [SearchedItemsItem]
}

// MARK: - Item
struct SearchedItemsItem: Codable {
    let kind, etag: String
    let id: ID
    let snippet: SearchedItemsSnippet
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
struct SearchedItemsSnippet: Codable {
    let publishedAt: Date
    let channelID, title, snippetDescription: String
    let thumbnails: SearchedItemsThumbnails
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
struct SearchedItemsThumbnails: Codable {
    let thumbnailsDefault, medium, high: SearchedItemsDefault

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high
    }
}

// MARK: - SearchedItemsDefault
struct SearchedItemsDefault: Codable {
    let url: String
    let width, height: Int?
}

// MARK: - PageInfo
struct SearchedItemsPageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
