//
//  Playlists.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 06/10/2020.
//

import Foundation

// MARK: - Playlists
struct Playlists: Codable {
    let kind, etag: String
    let nextPageToken: String?
    let pageInfo: PlaylistsPageInfo
    let items: [PlaylistsItem]
}

// MARK: - Item
struct PlaylistsItem: Codable {
    let kind, etag, id: String
    let snippet: PlaylistsSnippet
}

// MARK: - Snippet
struct PlaylistsSnippet: Codable {
    let publishedAt: Date
    let channelID, title, snippetDescription: String
    let thumbnails: PlaylistsThumbnails
    let channelTitle: String
    let localized: Localized

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle, localized
    }
}

// MARK: - Localized
struct Localized: Codable {
    let title, localizedDescription: String

    enum CodingKeys: String, CodingKey {
        case title
        case localizedDescription = "description"
    }
}

// MARK: - Thumbnails
struct PlaylistsThumbnails: Codable {
    let thumbnailsDefault, medium, high, standard: PlaylistsDefault?
    let maxres: PlaylistsDefault?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high, standard, maxres
    }
}

// MARK: - Default
struct PlaylistsDefault: Codable {
    let url: String
    let width, height: Int
}

// MARK: - PageInfo
struct PlaylistsPageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
