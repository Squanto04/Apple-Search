//
//  SearchResult.swift
//  Apple Search
//
//  Created by Jordan Lamb on 10/3/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation

struct MusicTLD: Decodable {
    let results: [MusicSearchResult]
}

struct MusicSearchResult: Decodable {
    let trackName: String?
    let artistName: String
    let artworkUrl100: String?
}

struct AppTLD: Decodable {
    let results: [AppSearchResult]
}

struct AppSearchResult: Decodable {
    let trackName: String
    let description: String
    let artworkUrl100: String?
}
